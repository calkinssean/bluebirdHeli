//
//  Date.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 11/27/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import Foundation

struct Day {
    
    var date = Date()
    var reservationOne: Reservation?
    var reservationTwo: Reservation?
    
    func available() -> Bool {
        if reservationOne == nil || reservationTwo == nil {
            return true
        }
        return false
    }
    
    func urlDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func save() {
        let dict: [String: Any] = [
            "date": date.timeIntervalSince1970
        ]
        let ref = FirebaseController().daysURL.child(urlDateString())
        FirebaseController().save(dict: dict, ref: ref)
        
        if reservationOne != nil {
            saveReservationOne()
        }
        if reservationTwo != nil {
            saveReservationTwo()
        }
    }
    
    func saveReservationOne() {
        
    }
    
    func saveReservationTwo() {
        
    }
    
}
