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
    var operatingArea: OperatingArea?
    var pickupTime: Date?
    var pickupLocation: PickupLocation?
    var numberOfAttendees: Int?
    var ref: DatabaseReference?
    
    init(){}
    
    init(dict: [String: Any]) {
        groupUID = dict["groupUID"] as? String
        pickupTime = Date(timeIntervalSince1970: dict["pickupTime"] as? Double ?? 0)
        numberOfAttendees = dict["numberOfAttendees"] as? Int ?? 0
        ref = Database.database().reference(fromURL: dict["ref"] as? String ?? "")
        if let operatingAreaString = dict["operatingArea"] as? String {
            if let operatingArea = OperatingArea(rawValue: operatingAreaString) {
                self.operatingArea = operatingArea
            }
        }
        if let pickupLocationString = dict["pickupLocation"] as? String {
            if let pickupLocation = PickupLocation(rawValue: pickupLocationString) {
                self.pickupLocation = pickupLocation
            }
        }
        
       
    }
    
    func initialized() -> Bool {
        if groupUID == nil {
            print("groupUID not initialized")
        }
        if operatingArea == nil {
            print("operating area not initialized")
        }
        if pickupTime == nil {
            print("pickup time not initialized")
        }
        if pickupLocation == nil {
            print("pickup location not initialized")
        }
        if numberOfAttendees == nil {
            print("nuber of attendees not initialized")
        }
        return groupUID != nil && operatingArea != nil && pickupTime != nil && pickupLocation != nil && numberOfAttendees != nil
    }
    
    mutating func save(ref: DatabaseReference) {
        self.ref = ref
        guard initialized() else {
            print("Reservation not saved, not initialized reservation model")
            return
        }
        let dict: [String: Any] = [
            "groupUID": groupUID!,
            "operatingArea": operatingArea!.rawValue,
            "pickupTime": pickupTime!.timeIntervalSince1970,
            "pickupLocation": pickupLocation!.rawValue,
            "numberOfAttendees": numberOfAttendees!,
            "ref": "\(ref)"
        ]
        FirebaseController().save(dict: dict, ref: ref)
        
    }
    
}
