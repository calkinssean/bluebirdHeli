//
//  WeatherTableViewCell.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 12/4/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet var leftHeader: UILabel!
    @IBOutlet var leftSubtext: UILabel!
    @IBOutlet var rightHeader: UILabel!
    @IBOutlet var rightSubtext: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpCell(leftHeader: String, leftSubtext: String, rightHeader: String, rightSubtext: String) {
        self.leftHeader.text = leftHeader
        self.leftSubtext.text = leftSubtext
        self.rightHeader.text = rightHeader
        self.rightSubtext.text = rightSubtext
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
