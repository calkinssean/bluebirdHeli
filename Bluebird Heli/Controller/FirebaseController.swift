//
//  FirebaseController.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 11/30/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class FirebaseController {
    
    let mediaItemChangedNotification = NSNotification(name: NSNotification.Name(rawValue: "mediaItemChanged"), object: nil)
    let mediaItemRemovedNotification = NSNotification(name: NSNotification.Name(rawValue: "mediaItemRemoved"), object: nil)
    let mediaItemAddedNotification = NSNotification(name: NSNotification.Name(rawValue: "mediaItemAdded"), object: nil)
   
    var baseURL: DatabaseReference {
        var configuration = Configuration()
        return configuration.environment.baseURL
    }
    
    var groupsURL: DatabaseReference {
        return baseURL.child("users")
    }
    
    var daysURL: DatabaseReference {
        return baseURL.child("days")
    }

    var reservationURL: DatabaseReference {
        return baseURL.child("reservations")
    }
    
    func signInUser(email: String, password: String, completion: @escaping (User?, Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            completion(user, error)
        }
    }
    
    func save(dict: [String: Any], ref: DatabaseReference) {
        guard ref != baseURL else { return }
        ref.updateChildValues(dict)
    }
    
    func observeDays() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateKey = dateFormatter.string(from: Date())

        daysURL.queryOrderedByKey().queryStarting(atValue: dateKey).observe(.childAdded) { (snapshot) in
            if let dayDict = snapshot.value as? [String: Any] {
                let day = Day(dict: dayDict)
                DataStore.shared.daysDict[day.urlDateString()] = day
            }
        }
        
        daysURL.queryOrderedByKey().queryStarting(atValue: dateKey).observe(.childChanged) { (snapshot) in
            if let dayDict = snapshot.value as? [String: Any] {
                let day = Day(dict: dayDict)
                DataStore.shared.daysDict[day.urlDateString()] = day
            }
        }
        
        daysURL.queryOrderedByKey().queryStarting(atValue: dateKey).observe(.childRemoved) { (snapshot) in
            if let dayDict = snapshot.value as? [String: Any] {
                let day = Day(dict: dayDict)
                DataStore.shared.daysDict[day.urlDateString()] = nil
            }
        }
   
    }
    
    func fetchGroup(with uid: String, sender: Any, completion: @escaping (String?) -> ()) {
        guard uid != "" else { return }
        groupsURL.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: Any] else {
                completion("There is no account attached to that authorization.")
                if let _ = sender as? AppDelegate {
                    self.logout()
                }
                return }
            DataStore.shared.currentGroup = Group(dict: dict)
            FirebaseController().setUpObservers()
            completion(nil)
        }
    }
    
    func reference(for group: Group) -> DatabaseReference {
        return groupsURL.child(group.uid)
    }
    
    func reduceRemainingTripsForCurrentGroup() {
        guard let remainingTrips = DataStore.shared.currentGroup?.remainingTrips, let uid = DataStore.shared.currentGroup?.uid else { return }
        DataStore.shared.currentGroup?.remainingTrips = remainingTrips - 1
        groupsURL.child(uid).child("remainingTrips").setValue(remainingTrips - 1)
    }
    
    func observeReservations() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateKey = dateFormatter.string(from: Date())
        let url = reservationURL.child(uid)
        
        url.queryOrderedByKey().queryStarting(atValue: dateKey).observe(.childAdded) { (snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            guard let ref = dict["ref"] as? String else { return }
            self.fetchReservation(by: ref, completion: { (reservation) in
                DataStore.shared.upcomingTrips.append(reservation)
            })
        }
        
        url.queryOrderedByKey().queryStarting(atValue: dateKey).observe(.childChanged) { (snapshot) in
            print(snapshot)
        }
        
        url.queryOrderedByKey().queryStarting(atValue: dateKey).observe(.childRemoved) { (snapshot) in
            print(snapshot)
        }
    }
    
    func fetchReservation(by ref: String, completion: @escaping (Reservation) -> ()) {
        let ref = Database.database().reference(fromURL: ref)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            completion(Reservation(dict: dict))
        }
    }
    
    func resetPassword(email: String, completion: @escaping (Bool, String?) -> ()) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func observeImages(for dateKey: String) {
        guard let uid = Auth.auth().currentUser?.uid else { print("No group uid"); return }
        baseURL.child("images").child(uid).child(dateKey).observe(.childAdded) { (snapshot) in
            if let timeStamp = Double(snapshot.key) {
                if let imageDict = snapshot.value as? [String: Any] {
                    if let url = imageDict["url"] as? String {
                        let storageURL = Storage.storage().reference(forURL: url)
                        self.downloadImage(ref: storageURL, completion: { (data) in
                            let mediaItem = Media(url: url, dateString: dateKey, date: timeStamp, type: .Image, data: data)
                            var mediaArray: [Media] = []
                            if let array = DataStore.shared.mediaDict[dateKey] {
                                mediaArray = array
                            }
                            mediaArray.append(mediaItem)
                            if !DataStore.shared.mediaSectionHeaders.contains(dateKey) {
                                DataStore.shared.mediaSectionHeaders.append(dateKey)
                            }
                            DataStore.shared.mediaDict[dateKey] = mediaArray.sorted{ $0.date < $1.date }
                            let arrayForSection = DataStore.shared.mediaDict[dateKey]
                            if let section = DataStore.shared.mediaSectionHeaders.index(of: dateKey), let item = arrayForSection?.index(where: {$0.date == mediaItem.date}) {
                                // object added notification
                            }
                            
                        })
                    }
                }
            }
        }
        baseURL.child("images").child(uid).child(dateKey).observe(.childRemoved) { (snapshot) in
            if let timeStamp = Double(snapshot.key) {
                if let array = DataStore.shared.mediaDict[dateKey] {
                    var mediaArray: [Media] = array
                    if let mediaItem = array.filter({$0.date == timeStamp}).first {
                        let arrayForSection = DataStore.shared.mediaDict[dateKey]
                        if let section = DataStore.shared.mediaSectionHeaders.index(of: dateKey), let item = arrayForSection?.index(where: {$0.date == mediaItem.date}) {
                            mediaArray.remove(at: item)
                            DataStore.shared.mediaDict[dateKey] = mediaArray.sorted{ $0.date < $1.date }
                            // object removed notification
                        }
                    }
                }
            }
        }
        baseURL.child("images").child(uid).child(dateKey).observe(.childChanged) { (snapshot) in
            if let timeStamp = Double(snapshot.key) {
                if let changedDict = snapshot.value as? [String: Any] {
                    if let array = DataStore.shared.mediaDict[dateKey], let url = changedDict["url"] as? String {
                        var mediaArray: [Media] = array
                        if var mediaItem = mediaArray.filter({$0.date == timeStamp}).first {
                            if mediaItem.url != url {
                                let storageURL = Storage.storage().reference(forURL: url)
                                self.downloadImage(ref: storageURL, completion: { (data) in
                                    mediaItem.data = data
                                    let arrayForSection = DataStore.shared.mediaDict[dateKey]
                                    if let section = DataStore.shared.mediaSectionHeaders.index(of: dateKey), let item = arrayForSection?.index(where: {$0.date == mediaItem.date}) {
                                        mediaArray[item] = mediaItem
                                        DataStore.shared.mediaDict[dateKey] = mediaArray
                                        // object changed notification
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    
    func observeImageDateKeys() {
        guard let uid = Auth.auth().currentUser?.uid else { print("No group uid"); return }
        baseURL.child("images").child(uid).observe(.childAdded) { (snapshot) in
            self.observeImages(for: snapshot.key)
        //    print(snapshot.key)
        
            if let datesDict = snapshot.value as? [String: Any] {
                for dateKey in datesDict.keys {
  //                  print(dateKey)
                }
            }
        }
        baseURL.child("images").child(uid).observe(.childRemoved) { (snapshot) in
            if let datesDict = snapshot.value as? [String: Any] {
                for dateKey in datesDict.keys {
   //                 print(dateKey)
                }
            }
        }
//        baseURL.child("images").child(uid).observe(.value) { (snapshot) in
//            if let datesDict = snapshot.value as? [String: Any] {
//                for dateKey in datesDict.keys {
//                    print(dateKey)
//                }
//            }
//        }
    }
    
    func observeImages() {
        observeImageDateKeys()
       // guard let uid = Auth.auth().currentUser?.uid else { print("No group uid"); return }
//        baseURL.child("images").child(uid).observe(.childAdded) { (snapshot) in
//            print("added dict")
//            print(snapshot)
//        }
//        baseURL.child("images").child(uid).observe(.childChanged) { (snapshot) in
//            print("changed dict")
//            print(snapshot)
//        }
//        baseURL.child("images").child(uid).observe(.childRemoved) { (snapshot) in
//            print("removed dict")
//            print(snapshot)
//        }
        
        
//        if let dateDict = datesDict[dateKey] as? [String: Any] {
//            for timeStamp in dateDict.keys {
//                if let imageDict = dateDict[timeStamp] as? [String: Any] {
//                    if let url = imageDict["url"] as? String {
//                        let storageURL = Storage.storage().reference(forURL: url)
//                        self.downloadImage(ref: storageURL, completion: { (data) in
//                            if let timeStampDouble = Double(timeStamp) {
//                                let mediaItem = Media(url: url, dateString: dateKey, date: timeStampDouble, type: .Image, data: data)
//                                var mediaArray: [Media] = []
//                                if let array = DataStore.shared.mediaDict[dateKey] {
//                                    mediaArray = array
//                                }
//                                mediaArray.append(mediaItem)
//                                DataStore.shared.mediaDict[dateKey] = mediaArray
//                                if !DataStore.shared.mediaSectionHeaders.contains(dateKey) {
//                                    DataStore.shared.mediaSectionHeaders.append(dateKey)
//                                }
//                                let arrayForSection = DataStore.shared.mediaDict[dateKey]
//                                if let section = DataStore.shared.mediaSectionHeaders.index(of: dateKey), let item = arrayForSection?.index(where: {$0.date == mediaItem.date}) {
//                                    UserDefaults.standard.set(section, forKey: "sectionToUpdate")
//                                    UserDefaults.standard.set(item, forKey: "itemToUpdate")
//                                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "updatedMediaController")))
//                                }
//                            }
//                        })
//                    }
//                }
//            }
//        }
        
//        baseURL.child("images").child(uid).observe(.value) { (snapshot) in
//            if let datesDict = snapshot.value as? [String: Any] {
//                for dateKey in datesDict.keys {
//                    print(dateKey)
//                }
//            }
//        }
    }
    
    func observeVideos() {
        guard let uid = Auth.auth().currentUser?.uid else { print("No group uid"); return }
        baseURL.child("videos").child(uid).observe(.value) { (snapshot) in
            if let datesDict = snapshot.value as? [String: Any] {
                for dateKey in datesDict.keys {
                    if let dateDict = datesDict[dateKey] as? [String: Any] {
                        for timeStamp in dateDict.keys {
                            if let imageDict = dateDict[timeStamp] as? [String: Any] {
                                if let url = imageDict["url"] as? String {
                                    self.downloadThumbnail(for: url, completion: { (data) in
                                        if let timeStampDouble = Double(timeStamp) {
                                            let embedURL = url.replacingOccurrences(of: "watch?v=", with: "embed/")
                                            let mediaItem = Media(url: embedURL, dateString: dateKey, date: timeStampDouble, type: .Video, data: data)
                                            var mediaArray: [Media] = []
                                            if let array = DataStore.shared.mediaDict[dateKey] {
                                                mediaArray = array
                                            }
                                            mediaArray.append(mediaItem)
                                            DataStore.shared.mediaDict[dateKey] = mediaArray
                                            if !DataStore.shared.mediaSectionHeaders.contains(dateKey) {
                                                DataStore.shared.mediaSectionHeaders.append(dateKey)
                                            }
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func downloadThumbnail(for videoURL: String, completion: @escaping (Data) -> ()) {
        let imageURLString = "\(videoURL.replacingOccurrences(of: "www", with: "img").replacingOccurrences(of: "watch?v=", with: "vi/"))/0.jpg"
        guard let imageURL = URL(string: imageURLString) else { return }
        URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            if let error = error {
                print(error)
                print(error.localizedDescription)
            }
            if let data = data {
                completion(data)
            }
        }.resume()
    }
    
    func downloadImage(ref: StorageReference, completion: @escaping (Data) -> ()) {
        ref.getData(maxSize: 10000 * 10000) { (data, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Image download error")
            } else {
                if let data = data {
                    completion(data)
                }
            }
        }
    }
    
    func setUpObservers() {
        WeatherController().setUpLocations()
        WeatherController().fetchWeatherHourly()
        FirebaseController().observeDays()
        FirebaseController().observeReservations()
        FirebaseController().observeImages()
        FirebaseController().observeVideos()
    }
    
    func logout() {
        
        do {
            try Auth.auth().signOut()
            DataStore.shared.currentGroup = nil
            DataStore.shared.daysDict = [:]
            DataStore.shared.upcomingTrips = []
            DataStore.shared.mediaDict = [:]
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "Login") as! UINavigationController
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.window?.rootViewController = rootViewController
            }
            
        } catch {
            print("failed logout")
        }
    }
    
}
