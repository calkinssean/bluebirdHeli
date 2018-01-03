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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setGradientBackground(colors: [Colors.translucentDarkGray.cgColor, Colors.translucentDarkerGray.cgColor])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(with reservation: Reservation) {
        guard let date = reservation.pickupTime else { return }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM dd h:mm a"
        self.dateLabel.text = formatter.string(from: date)
    }
    
    

}
