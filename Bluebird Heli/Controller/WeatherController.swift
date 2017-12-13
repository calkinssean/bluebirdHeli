//
//  WeatherController.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 12/1/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import Foundation

class WeatherController {
    
    func setUpLocations() {
        
        let northernLocation = Location()
        northernLocation.latitude = 41.07786
        northernLocation.longitude = -111.82708
        northernLocation.operatingArea = .northern
        DataStore.shared.northerOperatingArea = northernLocation
        
        let centralLocation = Location()
        centralLocation.latitude = 40.85764
        centralLocation.longitude = -111.05976
        centralLocation.operatingArea = .central
        DataStore.shared.centralOperatingArea = centralLocation
        
        let southernLocation = Location()
        southernLocation.latitude = 40.53284
        southernLocation.longitude = -111.64152
        southernLocation.operatingArea = .southern
        DataStore.shared.southernOperatingArea = southernLocation
        
    }
    
    func fetchWeather() {
        WeatherAPI().fetchWeather(for: DataStore.shared.northerOperatingArea)
        WeatherAPI().fetchWeather(for: DataStore.shared.centralOperatingArea)
        WeatherAPI().fetchWeather(for: DataStore.shared.southernOperatingArea)
    }
    
    func fetchWeatherHourly() {
        Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { (timer) in
            self.fetchWeather()
        }.fire()
    }
    
    func badWeather(conditions: [Conditions]) -> Bool {
        // TODO:
   //     print(conditions.count)
        return false
    }
    
    func conditions(for date: Date, for location: Location, conditionType: ConditionType) -> [Conditions] {
        var conditionsToFilter = [Conditions]()
        switch conditionType {
        case .daily:
            conditionsToFilter = location.weather.daily
        case .hourly:
            conditionsToFilter = location.weather.hourly
        default:
            break
        }
        return conditionsToFilter.filter({$0.time.timeIntervalSince1970 >= date.startInterval() && $0.time.timeIntervalSince1970 <= date.endInterval()})
    }
    
    
}
