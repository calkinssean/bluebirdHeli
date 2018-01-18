//
//  MediaViewController.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 1/16/18.
//  Copyright © 2018 Sean Calkins. All rights reserved.
//

import UIKit
import FirebaseStorage

class MediaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadImage() {
        let ref = Storage().reference()
        ref.getData(maxSize: 1000 * 1000) { (data, error) in
            print(data)
        }
    }
}
