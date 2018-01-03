//
//  UpcomingTripsViewController.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 1/2/18.
//  Copyright © 2018 Sean Calkins. All rights reserved.
//

import UIKit

class UpcomingTripsViewController: UIViewController {

    @IBOutlet var upcomingTripsTableView: UITableView!
    @IBOutlet var tripDetailsTableView: UITableView!
    
    let tripDetails = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.upcomingTripsTableView.tableFooterView = UIView()
        self.tripDetailsTableView.tableFooterView = UIView()
    }

}

extension UpcomingTripsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case upcomingTripsTableView:
            return DataStore.shared.upcomingTrips.count
        case tripDetailsTableView:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case upcomingTripsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UpcomingTripTableViewCell
            cell.setupCell(with: DataStore.shared.upcomingTrips[indexPath.row])
            return cell
        case tripDetailsTableView:
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "tripDetailsCell")!
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell")!
                return cell
            default:
                break
            }
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView {
        case upcomingTripsTableView:
            return 1
        case tripDetailsTableView:
            return 2
        default:
            break
        }
        return 0
    }
    
}

extension UpcomingTripsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch tableView {
        case tripDetailsTableView:
            switch section {
            case 0:
                return "Trip Details"
            case 1:
                return "Weather Details"
            default:
                return ""
            }
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch tableView {
        case tripDetailsTableView:
            switch section {
            case 0:
                return UITableViewAutomaticDimension
            case 1:
                return UITableViewAutomaticDimension
            default:
                return 0
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case upcomingTripsTableView:
            return 69
        case tripDetailsTableView:
            return 40
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case upcomingTripsTableView:
            break
        case tripDetailsTableView:
            break
        default:
            break
        }
    }
    
}
