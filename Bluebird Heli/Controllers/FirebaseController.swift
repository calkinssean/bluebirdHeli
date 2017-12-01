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
    
    let baseURL = Database.database().reference()
    let groupsURL = Database.database().reference().child("users")
    
    func signInUser(email: String, password: String, completion: @escaping (User?, Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            completion(user, error)
        }
    }
    
    func save(dict: [String: Any], refString: String) {
        guard refString != "" else { return }
        Database.database().reference(fromURL: refString).updateChildValues(dict)
    }
    
}
