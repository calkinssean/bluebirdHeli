//
//  Filterer.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 12/11/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import Foundation

class Filterer {
    
    func day(for date: Date) -> Day {
        let calendar = Calendar.current
        let comps1 = calendar.dateComponents([.year, .month, .day], from: date)
        for day in DataStore.shared.days {
            let comps2 = calendar.dateComponents([.year, .month, .day], from: day.date)
            if comps1 == comps2 {
                return day
            }
        }
        var day = Day()
        day.date = date
        return day
    }
    
}
