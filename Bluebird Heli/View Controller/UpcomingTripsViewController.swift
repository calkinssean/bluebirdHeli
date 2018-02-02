//
//  UpcomingTripsViewController.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 1/2/18.
//  Copyright © 2018 Sean Calkins. All rights reserved.
//

import UIKit
import MessageUI

class UpcomingTripsViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var noDataLabel: UILabel!
    @IBOutlet var upcomingTripsTableView: UITableView!
    @IBOutlet var tripDetailsTableView: UITableView!
    
    let numberFormatter = NumberFormatter()
    let formatter = DateFormatter()
    let measurementFormatter = MeasurementFormatter()
    let 🇺🇸 = Locale(identifier: "en_US")
    
    let tripDetailsHeaders = ["Pickup Location", "Pickup Time", "Group Size"]
    let weatherDetailHeaders = [["SUMMARY", "SUNRISE", "TEMPERATURE HIGH", "CHANCE OF PRECIP", "PRECIPITATION", "WIND", "VISIBILITY"], ["", "SUNSET", "TEMPERATURE LOW", "TYPE", "HUMIDITY", "GUSTS", "UV INDEX"]]
    
    var hourlyConditions = [Conditions]()
    var dailyConditions: Conditions?
    var selectedReservation: Reservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.locale = 🇺🇸
        self.upcomingTripsTableView.tableFooterView = UIView()
        self.tripDetailsTableView.tableFooterView = UIView()
    }
    
}

// MARK: - UITableViewDataSource
extension UpcomingTripsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case upcomingTripsTableView:
            return DataStore.shared.upcomingTrips.count
        case tripDetailsTableView:
            switch section {
            case 0:
                return tripDetailsHeaders.count
            case 1:
                return weatherDetailHeaders[section].count
            default:
                return 0
            }
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
                let cell = tableView.dequeueReusableCell(withIdentifier: "tripDetailsCell") as! TripDetailsTableViewCell
                cell.label.text = "\(tripDetailsHeaders[indexPath.row]):"
                cell.detailLabel.text = tripDetails(for: tripDetailsHeaders[indexPath.row], from: selectedReservation)
                
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! WeatherTableViewCell
                let leftHeader = weatherDetailHeaders[0][indexPath.row]
                let rightHeader = weatherDetailHeaders[1][indexPath.row]
                let leftSubtext = weatherDetailString(from: leftHeader, using: dailyConditions)
                let rightSubtext = weatherDetailString(from: rightHeader, using: dailyConditions)
                cell.setUpCell(leftHeader: leftHeader, leftSubtext: leftSubtext, rightHeader: rightHeader, rightSubtext: rightSubtext)
                return cell
            default:
                return UITableViewCell()
            }
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

// MARK: - UITableViewDelegate
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
           return 30
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
            selectedReservation = DataStore.shared.upcomingTrips[indexPath.row]
            guard let operatingArea = selectedReservation?.operatingArea, let pickupTime = selectedReservation?.pickupTime else { return }
            updateUIWeather(for: location(from: operatingArea), for: pickupTime)
            tripDetailsTableView.isHidden = false
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if tableView == tripDetailsTableView {
            view.tintColor = Colors.darkerGray
            let header = view as! UITableViewHeaderFooterView
            header.textLabel?.textColor = UIColor.white
            if section == 0 {
                if view.viewWithTag(222) == nil {
                    let disclosureButton = UIButton(type: .detailDisclosure)
                    disclosureButton.addTarget(self, action: #selector(detailDisclosureTapped), for: .touchUpInside)
                    disclosureButton.tag = 222
                    disclosureButton.tintColor = .white
                    let buttonHeight = disclosureButton.frame.height
                    disclosureButton.frame = CGRect(x: (view.frame.width - (buttonHeight) - 4), y: view.frame.height/2 - buttonHeight/2, width: buttonHeight, height: buttonHeight)
                    header.addSubview(disclosureButton)
                }
            } else {
                if let disclosureButton = view.viewWithTag(222) {
                    disclosureButton.removeFromSuperview()
                }
            }
           
        }
    }
    
}

// MARK: - UICollectionViewDataSource
extension UpcomingTripsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hourlyConditions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as! WeatherCollectionViewCell
        let conditions = self.hourlyConditions[indexPath.item]
        cell.configureCell(time: conditions.time, iconString: conditions.icon, temperature: conditions.temperature)
        return cell
    }
}

// MARK: - Helper
extension UpcomingTripsViewController {
    
    @objc func detailDisclosureTapped() {
        let alert = UIAlertController(title: "Edit Reservation", message: "In order to modify or cancel a reservation you must email customer support. Please include any details you would like changed or let us know if you would like to cancel.", preferredStyle: .alert)
        let openEmailControllerAction = UIAlertAction(title: "Open Email", style: .default) { (action) in
            self.displayEmailController()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
  
        alert.addAction(openEmailControllerAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func weatherDetailString(from header: String, using conditions: Conditions?) -> String {
        guard let conditions = conditions else { return "--" }
        formatter.dateFormat = "h:mm a"
        numberFormatter.maximumFractionDigits = 0
        measurementFormatter.numberFormatter = numberFormatter
        measurementFormatter.unitOptions = .providedUnit
        switch header {
        case "SUMMARY":
            return conditions.summary
        case "SUNRISE":
            return formatter.string(from: conditions.sunriseTime)
        case "SUNSET":
            return formatter.string(from: conditions.sunsetTime)
        case "TEMPERATURE HIGH":
            return measurementFormatter.string(from: conditions.temperatureHigh)
        case "TEMPERATURE LOW":
            return measurementFormatter.string(from: conditions.temperatureLow)
        case "CHANCE OF PRECIP":
            return "\(formattedNumberString(from: conditions.precipProbability))%"
        case "TYPE":
            if conditions.precipType == "" {
                return "--"
            }
            return conditions.precipType
        case "PRECIPITATION":
            return measurementFormatter.string(from: conditions.precipAccumulation)
        case "HUMIDITY":
            return "\(formattedNumberString(from: conditions.humidity))%"
        case "WIND":
            return "\(Converter().direction(from: conditions.windBearing)) \(measurementFormatter.string(from: conditions.windSpeed))"
        case "GUSTS":
            return measurementFormatter.string(from: conditions.windGust)
        case "VISIBILITY":
            if let visibility = conditions.visibility {
                return measurementFormatter.string(from: visibility)
            }
            return "--"
        case "UV INDEX":
            return "\(formattedNumberString(from: conditions.uvIndex))"
        default:
            return ""
        }
    }
    
    func formattedNumberString(from double: Double) -> String {
        guard let unwrappedFormattedNumberString = numberFormatter.string(from: NSNumber(value: double)) else { return "" }
        return unwrappedFormattedNumberString
    }
    
    func tripDetails(for header: String, from reservation: Reservation?) -> String {
        
        guard let pickupLocation = reservation?.pickupLocation, let  pickupTime = reservation?.pickupTime, let groupSize = reservation?.numberOfAttendees else { return  "" }
        switch header {
        case "Pickup Location":
            return pickupLocation.name
        case "Pickup Time":
            formatter.dateFormat = "h:mm a"
            return formatter.string(from: pickupTime)
        case "Group Size":
            return "\(groupSize)"
        default:
            return ""
        }
    }
    
    func updateUIWeather(for location: Location?, for date: Date) {
        guard let location = location else { return }
        hourlyConditions = WeatherController().conditions(for: date, for: location, conditionType: .hourly)
        if let conditions = WeatherController().conditions(for: date, for: location, conditionType: .daily).first {
            self.noDataLabel.isHidden = true
            dailyConditions = conditions
        } else {
            self.noDataLabel.isHidden = false
            dailyConditions = nil
        }
        self.collectionView.reloadData()
        tripDetailsTableView.reloadData()
    }
    
    func location(from operatingArea: OperatingArea) -> Location {
        switch operatingArea {
        case .northern:
            return DataStore.shared.northernOperatingArea
        case .central:
            return DataStore.shared.centralOperatingArea
        case .southern:
            return DataStore.shared.southernOperatingArea
        }
    }
}

extension UpcomingTripsViewController: MFMailComposeViewControllerDelegate {
    
    func displayEmailController() {
        if let pickupTime = selectedReservation?.pickupTime, let groupUID = selectedReservation?.groupUID {
            formatter.dateFormat = "EEEE MMM dd, hh:mm a"
            var config = Configuration()
            var messageBody = ""
            let controller = MFMailComposeViewController()
            controller.mailComposeDelegate = self
            controller.setToRecipients(["info@cloudveilmountainheli.com"])
            switch config.environment {
            case .Staging:
                controller.setSubject("Reservation Change Test")
                messageBody = "<h1>This is a test email</h1>Trip Date: \(formatter.string(from: pickupTime))<br>Server ID: \(groupUID)"
            case .Production:
                controller.setSubject("Reservation Change")
                messageBody = "<h1>Info for reservation needing modification</h1>Trip Date: \(formatter.string(from: pickupTime))<br>Server ID: \(groupUID)"
            }
            
            controller.setMessageBody(messageBody, isHTML: true)
            present(controller, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
}

