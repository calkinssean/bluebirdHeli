//
//  Conditions.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 11/27/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import Foundation

struct Conditions {
    
    var time: Date = Date()
    var temperatureMaxTime: Date = Date()
    var temperatureMinTime: Date = Date()
    var sunriseTime: Date = Date()
    var sunsetTime: Date = Date()
    var summary: String = ""
    var icon: String = ""
    var precipType: String = ""
    var precipProbability: Double = 0.0
    var precipAccumulation = Measurement<UnitLength>(value: 0.0, unit: .inches)
    var visibility = Measurement<UnitLength>(value: 0.0, unit: .miles)
    var temperature = Measurement<UnitTemperature>(value: 0.0, unit: .fahrenheit)
    var temperatureHigh = Measurement<UnitTemperature>(value: 0.0, unit: .fahrenheit)
    var temperatureLow = Measurement<UnitTemperature>(value: 0.0, unit: .fahrenheit)
    var apparentTemperature = Measurement<UnitTemperature>(value: 0.0, unit: .fahrenheit)
    var humidity: Double = 0.0
    var pressure: Double = 0.0
    var windSpeed = Measurement<UnitSpeed>(value: 0.0, unit: .milesPerHour)
    var windGust = Measurement<UnitSpeed>(value: 0.0, unit: .milesPerHour)
    var windBearing: Double = 0.0
    var cloudCover: Double = 0.0
    var uvIndex: Double = 0.0
    var ozone: Double = 0.0
    
    init(){}
    
    init(dict: [String: Any]) {
  
        time = Date(timeIntervalSince1970: dict["time"] as? Double ?? 0.0)
        sunriseTime = Date(timeIntervalSince1970: dict["sunriseTime"] as? Double ?? 0.0)
        sunsetTime = Date(timeIntervalSince1970: dict["sunsetTime"] as? Double ?? 0.0)
        summary = dict["summary"] as? String ?? ""
        icon = dict["icon"] as? String ?? ""
        precipProbability = dict["precipProbability"] as? Double ?? 0.0
        precipType = dict["precipType"] as? String ?? ""
        precipAccumulation = Measurement<UnitLength>(value: dict["precipAccumulation"] as? Double ?? 0.0, unit: .inches)
        visibility = Measurement<UnitLength>(value: dict["visibility"] as? Double ?? 0.0, unit: .miles)
        temperature = Measurement<UnitTemperature>(value: dict["temperature"] as? Double ?? 0.0, unit: .fahrenheit)
        temperatureHigh = Measurement<UnitTemperature>(value: dict["temperatureHigh"] as? Double ?? 0.0, unit: .fahrenheit)
        temperatureLow = Measurement<UnitTemperature>(value: dict["temperatureLow"] as? Double ?? 0.0, unit: .fahrenheit)
        apparentTemperature = Measurement<UnitTemperature>(value: dict["apparentTemperature"] as? Double ?? 0.0, unit: .fahrenheit)
        temperatureMaxTime = Date(timeIntervalSince1970: dict["temperatureMaxTime"] as? Double ?? 0.0)
        temperatureMinTime = Date(timeIntervalSince1970: dict["temperatureMinTime"] as? Double ?? 0.0)
        humidity = dict["humidity"] as? Double ?? 0.0
        pressure = dict["pressure"] as? Double ?? 0.0
        windSpeed = Measurement<UnitSpeed>(value: dict["windSpeed"] as? Double ?? 0.0, unit: .milesPerHour)
        windGust = Measurement<UnitSpeed>(value: dict["windGust"] as? Double ?? 0.0, unit: .milesPerHour)
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
