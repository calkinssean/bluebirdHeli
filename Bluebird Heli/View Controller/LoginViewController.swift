//
//  LoginViewController.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 11/21/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        FirebaseController().signInUser(email: email, password: password) { (user, error) in
            if let uid = user?.uid {
                FirebaseController().fetchGroup(with: uid, completion: { (group) in
                    DataStore.shared.currentGroup = group
                    self.userSignedIn()
                    self.showDashboard()
                    FirebaseController().observeDays()
                    FirebaseController().observeReservations()
                })
            }
        }
    }
    
    func userSignedIn() {
        WeatherController().setUpLocations()
        WeatherController().fetchWeatherHourly()
    }
    
    func showDashboard() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController = storyboard.instantiateViewController(withIdentifier: "Dashboard") as! UINavigationController
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController = rootViewController
        }
    }

}
