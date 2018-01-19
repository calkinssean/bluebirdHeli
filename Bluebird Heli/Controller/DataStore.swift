//
//  DataStore.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 11/30/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import Foundation

class DataStore {
    
    static let shared = DataStore()
    
    var currentGroup: Group?
    
    var upcomingTrips: [Reservation] = []
    
    var mediaSectionHeaders: [String] = []
    var mediaDict: [String: [Media]] = [:]
    
    var daysDict: [String: Day] = [:]
    
    var northernOperatingArea: Location = Location()
    var centralOperatingArea: Location = Location()
    var southernOperatingArea: Location = Location()
    
}
