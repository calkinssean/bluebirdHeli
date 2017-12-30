//
//  DateController.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 12/11/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import Foundation

class DateController {
    
    // Grab Day object for key from data store, if none exists, create a new Day object with date property set to passed in date.
    func day(from date: Date) -> Day {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        if let day = DataStore.shared.daysDict[dateString] {
            return day
        }
        let day = Day()
        day.date = date
        return day
    }
    
    
}
