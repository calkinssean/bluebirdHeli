//
//  Conditions.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 11/27/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import Foundation

struct Conditions {
    
    var time: Double = 0.0
    var sunriseTime: Double = 0.0
    var sunsetTime: Double = 0.0
    var summary: String = ""
    var icon: String = ""
    var precipProbability: Double = 0.0
    var precipType: String = ""
    var temperature: Double = 0.0
    var temperatureHigh: Double = 0.0
    var temperatureLow: Double = 0.0
    var apparentTemperature: Double = 0.0
    var humidity: Double = 0.0
    var pressure: Double = 0.0
    var windSpeed: Double = 0.0
    var windGust: Double = 0.0
    var windBearing: Double = 0.0
    var cloudCover: Double = 0.0
    var uvIndex: Double = 0.0
    var ozone: Double = 0.0
    
    init(){}
    
    init(dict: [String: Any]) {
  
        time = dict["time"] as? Double ?? 0.0
        sunriseTime = dict["sunriseTime"] as? Double ?? 0.0
        sunsetTime = dict["sunsetTime"] as? Double ?? 0.0
        summary = dict["summary"] as? String ?? ""
        icon = dict["icon"] as? String ?? ""
        precipProbability = dict["precipProbability"] as? Double ?? 0.0
        precipType = dict["precipType"] as? String ?? ""
        temperature = dict["temperature"] as? Double ?? 0.0
        temperatureHigh = dict["temperatureHigh"] as? Double ?? 0.0
        temperatureLow = dict["temperatureLow"] as? Double ?? 0.0
        apparentTemperature = dict["apparentTemperature"] as? Double ?? 0.0
        humidity = dict["humidity"] as? Double ?? 0.0
        pressure = dict["pressure"] as? Double ?? 0.0
        windSpeed = dict["windSpeed"] as? Double ?? 0.0
        windGust = dict["windGust"] as? Double ?? 0.0
        windBearing = dict["windBearing"] as? Double ?? 0.0
        cloudCover = dict["cloudCover"] as? Double ?? 0.0
        uvIndex = dict["uvIndex"] as? Double ?? 0.0
        ozone = dict["ozone"] as? Double ?? 0.0
    }
    
}

enum ConditionType: String {
    case hourly = "Hourly"
    case daily = "Daily"
    case currently = "Currently"
}
