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

class FirebaseController {
   
    var baseURL: DatabaseReference {
        var configuration = Configuration()
        return configuration.environment.baseURL
    }
    
    var groupsURL: DatabaseReference {
        return baseURL.child("users")
    }
    
    var datesURL: DatabaseReference {
        return baseURL.child("days")
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
    
    func observeDates() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateKey = dateFormatter.string(from: Date())

        datesURL.queryOrderedByKey().queryStarting(atValue: dateKey).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.value is NSNull {
                
            } else {
                print("ordered by key date string")
                print(snapshot)
            }
        }
        
        datesURL.child("2017-12-15").child("date").setValue("prius")
   
    }
    
    func fetchGroup(with uid: String, completion: @escaping (Group) -> ()) {
        guard uid != "" else { return }
        groupsURL.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            completion(Group(dict: dict))
        }
    }
    
    func reference(for group: Group) -> DatabaseReference {
        return groupsURL.child(group.uid)
    }
    
}
