//
//  UIView+Extension.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 12/28/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import UIKit

extension UIView {
    
    func setGradientBackground(colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
