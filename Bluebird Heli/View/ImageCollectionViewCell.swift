//
//  MediaCollectionViewCell.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 1/18/18.
//  Copyright © 2018 Sean Calkins. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var selectionImage: UIImageView!
    @IBOutlet var playImage: UIImageView!
    
    var mediaType: MediaType!
    
    var isEditing: Bool = false {
        didSet {
            if mediaType == .Image {
                selectionImage.isHidden = !isEditing
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isEditing {
                if mediaType == .Image {
                    selectionImage.image = isSelected ? UIImage(named: "Checked") : UIImage(named: "Unchecked")
                }
            }
        }
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
}
