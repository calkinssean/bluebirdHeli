//
//  WeatherCollectionViewCell.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 11/30/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var amPmLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!
    
    func configureCell(time: Date, iconString: String, temperature: Measurement<UnitTemperature>) {
        
        let dateFormatter = DateFormatter()
        let measurementFormatter = MeasurementFormatter()
        let numberFormatter = NumberFormatter()
        let 🇺🇸 = Locale(identifier: "en_US")
       
        numberFormatter.maximumFractionDigits = 0
        measurementFormatter.locale = 🇺🇸
        measurementFormatter.numberFormatter = numberFormatter
        dateFormatter.dateFormat = "h"
        timeLabel.text = dateFormatter.string(from: time)
        dateFormatter.dateFormat = "a"
        amPmLabel.text = dateFormatter.string(from: time)
        if let icon = UIImage(named: iconString) {
            iconImage.image = icon
        }
        temperatureLabel.text = measurementFormatter.string(from: temperature)
    }
    
}
