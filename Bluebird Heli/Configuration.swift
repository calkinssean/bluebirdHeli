//
//  Configuration.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 12/1/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

enum Environment: String {
    
    case Staging = "staging"
    case Production = "production"
    
    var baseURL: DatabaseReference {
        if Auth.auth().currentUser?.uid == "Lp1pRZPCY8QnRmpCKnPPAwslmE73" {
            return Database.database().reference().child("staging")
        }
        switch self {
        case .Staging: return Database.database().reference().child("staging")
        case .Production: return Database.database().reference().child("production")
        }
    }
}

struct Configuration {
    lazy var environment: Environment = {
        if let configuration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String {
            if configuration.range(of: "Staging") != nil {
                return Environment.Staging
            }
        }
        if Auth.auth().currentUser?.uid == "Lp1pRZPCY8QnRmpCKnPPAwslmE73" {
            return Environment.Staging
        }
        return Environment.Production
    }()
}
