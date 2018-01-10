//
//  NavigationController+Extension.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 1/10/18.
//  Copyright © 2018 Sean Calkins. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    func hideNavigationBar() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold), NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
}
