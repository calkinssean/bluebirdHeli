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
    
    var northerOperatingArea: Location {
        let location = Location()
        location.latitude = 41.07786
        location.longitude = 111.82708
        location.name = "Northern Operating Area"
        return location
    }
    
    var centralOperatingArea: Location {
        let location = Location()
        location.latitude = 40.85764
        location.longitude = 111.05976
        location.name = "Central Operating Area"
        return location
    }
    
    var southernOperatingArea: Location {
        let location = Location()
        location.latitude = 40.53284
        location.longitude = 111.64152
        location.name = "Southern Operating Area"
        return location
    }
}
