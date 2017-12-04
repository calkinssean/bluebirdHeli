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
        return calendar.dateComponents([.month, .day], from: self) == calendar.dateComponents([.month, .day], from: Date())
    }
    
}
