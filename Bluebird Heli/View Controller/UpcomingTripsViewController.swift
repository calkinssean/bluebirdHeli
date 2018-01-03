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

    }

}

extension UpcomingTripsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStore.shared.upcomingTrips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UpcomingTripTableViewCell
        cell.setupCell(with: DataStore.shared.upcomingTrips[indexPath.row])
        return cell
    }
    
}

extension UpcomingTripsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
