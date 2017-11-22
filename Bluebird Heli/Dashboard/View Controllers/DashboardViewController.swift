//
//  DashboardViewController.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 11/21/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    let rows = [
    "Schedule A Trip",
    "Photos/Videos"
    ]
    
    let imageNames = ["helicopter", "media"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension DashboardViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dashboardCell", for: indexPath) as! DashboardTableViewCell
        if let image = UIImage(named: imageNames[indexPath.row]) {
            cell.configureCell(with: image, text: rows[indexPath.row])
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rows.count
    }
    
}

extension DashboardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            break
        case 1:
            break
        default:
            break
        }
    }
    
}
