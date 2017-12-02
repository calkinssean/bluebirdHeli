//
//  DashboardTableViewCell.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 11/21/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import UIKit

class DashboardTableViewCell: UITableViewCell {

    @IBOutlet var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet var imageHeight: NSLayoutConstraint!
    
    @IBOutlet var parallaxImage: UIImageView!
    @IBOutlet var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(with image: UIImage, text: String) {
        self.parallaxImage.image = image
        self.label.text = text
    }
    
}
