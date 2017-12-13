//
//  BorderView.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 12/11/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import UIKit

@IBDesignable
class BorderView: UIView {
    
    @IBInspectable var borderColor: UIColor = UIColor.clear
    @IBInspectable var borderWidth: CGFloat = 0
    @IBInspectable var cornerRadius: CGFloat = 0
    
    override func draw(_ rect: CGRect) {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
    
}
