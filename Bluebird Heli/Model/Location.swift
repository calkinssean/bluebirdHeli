//
//  Location.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 11/27/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import Foundation

class Location {
    
    var operatingArea: OperatingArea?
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    
    var weather: Weather = Weather()
    
}

enum OperatingArea: String {
    case northern = "Northern Operating Area"
    case central = "Central Operating Area"
    case southern = "Southern Operating Area"
}

enum PickupLocation: String {
    case heber = "Heber Hangar"
    case northSaltLake = "North Salt Lake Hangar"
}

