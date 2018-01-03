//
//  UpcomingTripsViewController.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 1/2/18.
//  Copyright © 2018 Sean Calkins. All rights reserved.
//

import UIKit

class UpcomingTripsViewController: UIViewController {

    @IBOutlet var tripDetailsTableView: UITableView!
    @IBOutlet var upcomingTripsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.upcomingTripsTableView.tableFooterView = UIView()
    }

}

extension UpcomingTripsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case tripDetailsTableView:
            return 0
        case upcomingTripsTableView:
            return DataStore.shared.upcomingTrips.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case tripDetailsTableView:
            return UITableViewCell()
        case upcomingTripsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UpcomingTripTableViewCell
            cell.setupCell(with: DataStore.shared.upcomingTrips[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
       
    }
    
}

extension UpcomingTripsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case tripDetailsTableView:
            return 0
        case upcomingTripsTableView:
            return 69
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case tripDetailsTableView:
            break
        case upcomingTripsTableView:
            break
        default:
            break
        }
    }
    
}
