//
//  Constants.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 12/28/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import UIKit

struct Colors {
    
    static let translucentDarkGray = UIColor(red: 1/3, green: 1/3, blue: 1/3, alpha: 0.69)
    static let translucentDarkerGray = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 0.69)
    
    static let darkGray = UIColor.darkGray
    static let darkerGray = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.00)
    static let outsideMonthTextColor = UIColor.clear
    static let selectedDayViewColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
    static let availableViewColor = UIColor(red:0.51, green:0.62, blue:0.39, alpha:1.00)
    static let unavailableViewColor = UIColor(red:0.57, green:0.08, blue:0.14, alpha:1.00)
    static let standbyViewColor = UIColor(red:0.76, green:0.72, blue:0.12, alpha:1.00)
}

let sectionToReloadKey = "sectionToReloadKey"
let itemToReloadKey = "itemToReloadKey"
let sectionToRemoveKey = "sectionToRemoveKey"
let itemToRemoveKey = "itemToRemoveKey"
let sectionToAddKey = "sectionToAddKey"
let itemToAddKey = "itemToAddKey"

let mediaItemChangedNotificationName = Notification.Name(rawValue: "mediaItemChanged")
let mediaItemRemovedNotificationName = Notification.Name(rawValue: "mediaItemRemoved")
let mediaItemAddedNotificationName = Notification.Name(rawValue: "mediaItemAdded")

