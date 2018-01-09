//
//  User.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 11/27/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Group {
    
    var uid: String = ""
    var email: String = ""
    var membershipPackage: Package
    var remainingTrips: Int = 0
    var ref = DatabaseReference()
    
    enum Package: String {
        case gold = "gold"
        case silver = "silver"
        case none = ""
    }
   
    init(dict: [String: Any]) {
        uid = dict["uid"] as? String ?? ""
        email = dict["email"] as? String ?? ""
        membershipPackage = Package(rawValue: dict["package"] as? String ?? "")!
        remainingTrips = dict["remainingTrips"] as? Int ?? remainingTrips(from: membershipPackage)
        ref = FirebaseController().groupsURL.child(uid)
    }
    
    func save() {
        let dict: [String: Any] = [
            "uid": uid,
            "email": email,
            "package": membershipPackage.rawValue,
            "remainingTrips": remainingTrips,
            "ref": "\(ref)"
        ]
        FirebaseController().save(dict: dict, ref: FirebaseController().groupsURL.child(uid))
    }
    
    func remainingTrips(from package: Package) -> Int {
        switch package {
        case .gold:
            return 10
        case .silver:
            return 5
        case .none:
            return 0
        }
    }
}


