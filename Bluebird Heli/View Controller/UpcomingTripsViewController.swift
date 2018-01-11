//
//  UpcomingTripsViewController.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 1/2/18.
//  Copyright © 2018 Sean Calkins. All rights reserved.
//

import UIKit

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
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editReservationAlert))
        navigationItem.rightBarButtonItem = editButton
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
            selectedReservation = DataStore.shared.upcomingTrips[indexPath.row]
            guard let operatingArea = selectedReservation?.operatingArea, let pickupTime = selectedReservation?.pickupTime else { return }
            updateUIWeather(for: location(from: operatingArea), for: pickupTime)
        case tripDetailsTableView:
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = Colors.darkerGray
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
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
            return pickupLocation.rawValue
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
            self.tripDetailsTableView.isHidden = false
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
   
    @objc func editReservationAlert() {
        let alert = UIAlertController(title: "Edit Trip", message: "What would you like to do?", preferredStyle: .actionSheet)
        let editPickupLocationAction = UIAlertAction(title: "Edit Pickup Location", style: .default, handler: nil)
        let editPickupTimeAction = UIAlertAction(title: "Edit Pickup Time", style: .default, handler: nil)
        let editGroupSizeAction = UIAlertAction(title: "Edit Group Size", style: .default, handler: nil)
        let cancelReservationAction = UIAlertAction(title: "Cancel Reservation", style: .destructive, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(editPickupLocationAction)
        alert.addAction(editPickupTimeAction)
        alert.addAction(editGroupSizeAction)
        alert.addAction(cancelReservationAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
