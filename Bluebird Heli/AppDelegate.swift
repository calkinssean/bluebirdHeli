//
//  AppDelegate.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 11/21/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        setUpLocations()
        fetchWeather()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func fetchWeather() {
        WeatherAPI().fetchWeather(for: DataStore.shared.northerOperatingArea)
        WeatherAPI().fetchWeather(for: DataStore.shared.centralOperatingArea)
        WeatherAPI().fetchWeather(for: DataStore.shared.southernOperatingArea)
    }

    func setUpLocations() {
        
        let northernLocation = Location()
        northernLocation.latitude = 41.07786
        northernLocation.longitude = 111.82708
        northernLocation.name = "Northern Operating Area"
        DataStore.shared.northerOperatingArea = northernLocation
        
        let centralLocation = Location()
        centralLocation.latitude = 40.85764
        centralLocation.longitude = 111.05976
        centralLocation.name = "Central Operating Area"
        DataStore.shared.centralOperatingArea = centralLocation
        
        let southernLocation = Location()
        southernLocation.latitude = 40.53284
        southernLocation.longitude = 111.64152
        southernLocation.name = "Southern Operating Area"
        DataStore.shared.southernOperatingArea = southernLocation
        
    }

}

