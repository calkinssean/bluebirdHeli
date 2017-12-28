//
//  UIView+Extension.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 12/28/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import UIKit

extension UIView {
    
    func setGradientBackgrou(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 0.1]
        gradientLayer.locations = [1.0, 1.0]
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
