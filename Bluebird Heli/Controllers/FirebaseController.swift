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
    
    
    
    func signInUser(email: String, password: String, completion: @escaping (User?, Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            completion(user, error)
        }
    }
    
    func save(dict: [String: Any], refString: String) {
        guard refString != "" else { return }
        Database.database().reference(fromURL: refString).updateChildValues(dict)
    }
    
    func fetchGroup(with uid: String, completion: @escaping (Group) -> ()) {
        guard uid != "" else { return }
//        groupsURL.child(uid).observeSingleEvent(of: .value) { (snapshot) in
//            guard let dict = snapshot.value as? [String: Any] else { return }
//            completion(Group(dict: dict))
//        }
    }
    
}
