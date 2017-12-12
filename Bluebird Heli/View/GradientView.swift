//
//  GradientView.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 12/11/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import UIKit

@IBDesignable final class GradientView: UIView {
    
    @IBInspectable var startColor: UIColor = UIColor.clear
    @IBInspectable var endColor: UIColor = UIColor.clear
    @IBInspectable var cornerRadius: CGFloat = 10
    
    override func draw(_ rect: CGRect) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: CGFloat(0),
                                y: CGFloat(0),
                                width: self.frame.size.width,
                                height: self.frame.size.height)
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.zPosition = -1
        layer.addSublayer(gradient)
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
    }
    
}
