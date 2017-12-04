//
//  Extensions.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 12/4/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import Foundation

extension Date {
    
    func isWeekend() -> Bool {
        let calendar = Calendar.current
        return calendar.component(.weekday, from: self) == 1 || calendar.component(.weekday, from: self) == 7
    }
    
    func isToday() -> Bool {
        let calendar = Calendar.current
        return calendar.date(self, matchesComponents: calendar.dateComponents([.month, .day], from: Date()))
    }
  
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
    
}
