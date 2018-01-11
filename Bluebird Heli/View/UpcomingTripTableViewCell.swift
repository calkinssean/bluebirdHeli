//
//  UpcomingTripTableViewCell.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 1/3/18.
//  Copyright © 2018 Sean Calkins. All rights reserved.
//

import UIKit

class UpcomingTripTableViewCell: UITableViewCell {
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var selectedView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setGradientBackground(colors: [Colors.translucentDarkGray.cgColor, Colors.translucentDarkerGray.cgColor])
        selectedView.layer.borderColor = UIColor.white.cgColor
        selectedView.layer.borderWidth = 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            selectedView.isHidden = false
        } else {
            selectedView.isHidden = true
        }
    }
    
    func setupCell(with reservation: Reservation) {
        guard let date = reservation.pickupTime else { return }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM dd h:mm a"
        self.dateLabel.text = formatter.string(from: date)
    }
    
    

}
