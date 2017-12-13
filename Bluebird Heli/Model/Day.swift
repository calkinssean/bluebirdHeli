//
//  Date.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 11/27/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Day {
    
    var date = Date()
    var reservationOne: Reservation?
    var reservationTwo: Reservation?
    var ref: DatabaseReference?
    
    init(){}
    
    init(dict: [String: Any]) {
        parseData(dict: dict)
    }
    
    func available(with location: Location) -> Bool {
        if reservationOne != nil && reservationTwo != nil {
            return false
        }
        if reservationOne?.operatingArea == location.operatingArea || reservationTwo?.operatingArea == location.operatingArea {
            return false
        }
        let conditionsForDay = WeatherController().conditions(for: date, for: location, conditionType: .daily)
        if WeatherController().badWeather(conditions: conditionsForDay) {
            return false
        }
        if date.isToday() || date.isTomorrow() {
            return false
        }
        return true
    }
    
    mutating func parseData(dict: [String: Any]) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dict["date"] as? String ?? "") {
            self.date = date
        }
        ref = Database.database().reference(fromURL: dict["ref"] as? String ?? "")
        if let reservationOneDict = dict["reservationOne"] as? [String: Any] {
            
        }
        if let reservationTwoDict = dict["reservationTwo"] as? [String: Any] {
            
        }
    }
    
    func urlDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    mutating func save() {
        
        let ref = FirebaseController().daysURL.child(urlDateString())
        self.ref = ref
        
        let dict: [String: Any] = [
            "date": urlDateString(),
            "ref": "\(ref)"
        ]
        FirebaseController().save(dict: dict, ref: ref)
        
        if reservationOne != nil {
            saveReservationOne()
        }
        if reservationTwo != nil {
            saveReservationTwo()
        }
    }
    
    mutating func saveReservationOne() {
        guard let ref = ref else {
            print("Reservation not saved, nil ref day model")
            return
        }
        let reservationOneRef = ref.child("reservationOne")
        reservationOne?.save(ref: reservationOneRef)
    }
    
    mutating func saveReservationTwo() {
        guard let ref = ref else {
            print("Reservation not saved, nil ref day model")
            return
        }
        let reservationOneRef = ref.child("reservationTwo")
        reservationOne?.save(ref: reservationOneRef)
    }
    
}
