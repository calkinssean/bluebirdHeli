//
//  User.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 11/27/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import Foundation

struct Group {
    
    var uid: String = ""
    var email: String = ""
    var ref: String = ""
    var membershipPackage: Package
    var remainingTrips: Int = 0
    
    enum Package: String {
        case gold = "gold"
        case silver = "silver"
        case none = ""
    }
    
    init(dict: [String: Any]) {
        uid = dict["uid"] as? String ?? ""
        email = dict["email"] as? String ?? ""
        ref = dict["ref"] as? String ?? ""
        membershipPackage = Package(rawValue: dict["package"] as? String ?? "")!
        remainingTrips = dict["remainingTrips"] as? Int ?? remainingTrips(from: membershipPackage)
    }
    
    func save() {
        let dict: [String: Any] = [
            "uid": uid,
            "email": email,
            "ref": ref,
            "package": membershipPackage.rawValue,
            "remainingTrips": remainingTrips
        ]
        FirebaseController().save(dict: dict, refString: ref)
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


