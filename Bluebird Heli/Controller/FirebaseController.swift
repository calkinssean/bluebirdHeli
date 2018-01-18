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
    
    func fetchGroup(with uid: String, completion: @escaping (Group) -> ()) {
        guard uid != "" else { return }
        groupsURL.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: Any] else {
                // TODO: - Log out
                
                return }
            completion(Group(dict: dict))
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
    
    func observeImages() {
        guard let uid = Auth.auth().currentUser?.uid else { print("No group uid"); return }
        baseURL.child("images").child(uid).observe(.value) { (snapshot) in
            if let datesDict = snapshot.value as? [String: Any] {
                for key in datesDict.keys {
                    if let dateDict = datesDict[key] as? [String: Any] {
                        for value in dateDict.values {
                            if let imageDict = value as? [String: Any] {
                                if let url = imageDict["url"] as? String {
                                    print(url)
                                }
                            }
                        }
                    }
                }
            }
            
        }
    }
    
    func downloadImage(ref: StorageReference) {
        
    }
    
    func downloadVideo(ref: StorageReference) {
        
    }
    
}
