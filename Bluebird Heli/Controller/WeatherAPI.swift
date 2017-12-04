//
//  WeatherAPI.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 11/27/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import Foundation

class WeatherAPI {
    
    fileprivate let apiSecret = "0548447fc763adaa4dd0fa565dd55e98"
    fileprivate let baseURL = "https://api.darksky.net/forecast"
    fileprivate let exclusions = "exclude=minutely,flags"
    fileprivate let extend = "extend=hourly"

    func fetchWeather(for location: Location) {
        
        location.weather.daily.removeAll()
        location.weather.hourly.removeAll()
        
        // construct url
        let urlString = "\(baseURL)/\(apiSecret)/\(location.latitude),\(location.longitude)?,\(exclusions)&\(extend)"
        APIController().get(urlString: urlString) { (dict) in
            if let currently = dict["currently"] as? [String: Any] {
                location.weather.currently = Conditions(dict: currently)
            }
            if let hourlyDict = dict["hourly"] as? [String: Any] {
                if let hourlyArray = hourlyDict["data"] as? [[String: Any]] {
                    for dict in hourlyArray {
                        location.weather.hourly.append(Conditions(dict: dict))
                    }
                }
            }
            if let dailyDict = dict["daily"] as? [String: Any] {
                if let dailyArray = dailyDict["data"] as? [[String: Any]] {
                    for dict in dailyArray {
                        location.weather.daily.append(Conditions(dict: dict))
                    }
                }
            }
            print(location.weather.hourly.count)
        }
    }
    
}
