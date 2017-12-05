//
//  ConversionController.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 12/5/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import Foundation

class Converter {
    
    func inches(from centimeters: Double) -> Measurement<UnitLength> {
        let heightCentimeters = Measurement(value: centimeters, unit: UnitLength.centimeters)
        return heightCentimeters.converted(to: UnitLength.inches)
    }
    
    func miles(from kilometers: Double) -> Measurement<UnitLength> {
        let lengthKilometers = Measurement(value: kilometers, unit: UnitLength.miles)
        return lengthKilometers.converted(to: UnitLength.miles)
    }
    
    func milesPerHour(from metersPerSecond: Double) -> Measurement<UnitSpeed> {
        let metersPerSecond = Measurement(value: metersPerSecond, unit: UnitSpeed.metersPerSecond)
        return metersPerSecond.converted(to: UnitSpeed.milesPerHour)
    }

    func fahrenheit(from celsius: Double) {
        let temperatureCelsius = Measurement(value: celsius, unit: UnitTemperature.celsius)
        return temperatureCelsius.converted(to: UnitTemperature.fahrenheit)
    }
}
