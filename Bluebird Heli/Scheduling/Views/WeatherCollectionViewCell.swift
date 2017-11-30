//
//  WeatherCollectionViewCell.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 11/30/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!
    
    let numberFormatter = NumberFormatter()
    let dateFormatter = DateFormatter()
    
    func configureCell(time: Double, iconString: String, temperature: Double) {
        
        numberFormatter.maximumFractionDigits = 0
        dateFormatter.dateFormat = "hha"
        if let icon = UIImage(named: iconString) {
            iconImage.image = icon
        }
        timeLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: time))
        temperatureLabel.text = "\(numberFormatter.string(from: temperature as NSNumber) ?? "0")º"
    }
    
}
