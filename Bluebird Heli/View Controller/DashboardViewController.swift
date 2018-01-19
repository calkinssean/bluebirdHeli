//
//  DashboardViewController.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 11/21/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import UIKit
import FirebaseAuth

class DashboardViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    let rows = ["Schedule A Trip", "Photos/Videos", "Upcoming Trips"]
    let imageNames = ["helicopter", "media", "upcomingTrips"]
    
    var parallaxOffsetSpeed: CGFloat = 200
    var cellHeight: CGFloat = 420
    var parallaxImageHeight: CGFloat {
        let maxOffset = (sqrt(pow(cellHeight, 2) + 4 * parallaxOffsetSpeed * self.tableView.frame.height) - cellHeight) / 2
        return maxOffset + cellHeight
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutAlert))
        navigationItem.leftBarButtonItem = logoutButton
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parallaxOffset(newOffsetY: CGFloat, cell: UITableViewCell) -> CGFloat {
        return (newOffsetY - cell.frame.origin.y) / parallaxImageHeight * parallaxOffsetSpeed
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in tableView.visibleCells as! [DashboardTableViewCell] {
            cell.imageTopConstraint.constant = self.parallaxOffset(newOffsetY: tableView.contentOffset.y, cell: cell)
        }
    }
    
    @objc func logoutAlert() {
        let alert = UIAlertController(title: "Logout?", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            self.logout()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func logout() {
        
        do {
            try Auth.auth().signOut()
            DataStore.shared.currentGroup = nil
            DataStore.shared.daysDict = [:]
            DataStore.shared.upcomingTrips = []
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "Login") as! UINavigationController
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.window?.rootViewController = rootViewController
            }
            
        } catch {
            print("failed logout")
        }
    }
    
}

extension DashboardViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dashboardCell", for: indexPath) as! DashboardTableViewCell
        if let image = UIImage(named: imageNames[indexPath.row]) {
            cell.configureCell(with: image, text: rows[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rows.count
    }
    
}

extension DashboardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "showSchedulingSegue", sender: self)
        case 1:
            self.performSegue(withIdentifier: "showMediaSegue", sender: self)
        case 2:
            self.performSegue(withIdentifier: "upcomingTripsSegue", sender: self)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 575
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
}
