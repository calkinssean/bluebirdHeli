//
//  Reservation.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 11/27/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Reservation {

    var groupUID: String?
    var location: OperatingArea?
    var pickupTime: Date?
    var pickupLocation: PickupLocation?
    var numberOfAttendees: Int?
    var ref: DatabaseReference?
    
    func initialized() -> Bool {
        return groupUID != nil && location != nil && pickupTime != nil && pickupLocation != nil && numberOfAttendees != nil
    }
    
    mutating func save(ref: DatabaseReference) {
        self.ref = ref
        if initialized() {
            let dict: [String: Any] = [
                "groupUID": groupUID!,
                "location": location!.rawValue,
                "pickupTime": pickupTime!.timeIntervalSince1970,
                "pickupLocation": pickupLocation!.rawValue,
                "numberOfAttendees": numberOfAttendees!,
                "ref": "\(ref)"
            ]
            FirebaseController().save(dict: dict, ref: ref)
        }
    }
    
}
