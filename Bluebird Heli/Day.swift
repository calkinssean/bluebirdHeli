//
//  Date.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 11/27/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import Foundation

struct Day {
    
    var date: Date?
    var reservationOne: Reservation?
    var reservationTwo: Reservation?
    
    func available() -> Bool {
        if reservationOne != nil || reservationTwo != nil {
            return true
        }
        return false
    }
    
    func isToday() -> Bool {
        return true
    }
    
}
