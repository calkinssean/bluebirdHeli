//
//  Weather.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 11/27/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import Foundation

struct Weather {
    
    var currently = Conditions()
    var daily = [Conditions]()
    var hourly = [Conditions]()
    
}

