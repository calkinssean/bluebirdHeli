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
    
    let numberFormatter = NumberFormatter()
    let dateFormatter = DateFormatter()
    
    func configureCell(time: Date, iconString: String, temperature: Double) {
       
        dateFormatter.dateFormat = "h"
        timeLabel.text = dateFormatter.string(from: time)
        dateFormatter.dateFormat = "a"
        amPmLabel.text = dateFormatter.string(from: time)
        if let icon = UIImage(named: iconString) {
            iconImage.image = icon
        }
        numberFormatter.maximumFractionDigits = 0
        temperatureLabel.text = "\(numberFormatter.string(from: temperature as NSNumber) ?? "0")º"
    }
    
}
