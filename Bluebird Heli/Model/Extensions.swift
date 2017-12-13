//
//  Extensions.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 12/4/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import UIKit

extension Date {
    
    func isWeekend() -> Bool {
        let calendar = Calendar.current
        return calendar.component(.weekday, from: self) == 1 || calendar.component(.weekday, from: self) == 7
    }
    
    func isToday() -> Bool {
        let calendar = Calendar.current
        return calendar.date(self, matchesComponents: calendar.dateComponents([.month, .day], from: Date()))
    }
  
    func isTomorrow() -> Bool {
        let calendar = Calendar.current
        let tomorrowComps = calendar.dateComponents([.day], from: self)
        return calendar.date(self, matchesComponents: tomorrowComps)
    }
    
    func startInterval() -> Double {
        let calendar = Calendar.current
        return calendar.date(bySettingHour: 0, minute: 0, second: 0, of: self)!.timeIntervalSince1970
    }
    
    func endInterval() -> Double {
        let calendar = Calendar.current
        return calendar.date(bySettingHour: 23, minute: 59, second: 59, of: self)!.timeIntervalSince1970
    }
    
}

