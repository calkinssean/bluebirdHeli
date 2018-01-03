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
    
    let numberFormatter = NumberFormatter()
    let formatter = DateFormatter()
    let measurementFormatter = MeasurementFormatter()
    let 🇺🇸 = Locale(identifier: "en_US")
    
    let tripDetailsHeaders = ["Pickup Location", "Pickup Time", "Group Size"]
    let weatherDetailHeaders = [["SUMMARY", "SUNRISE", "TEMPERATURE HIGH", "CHANCE OF PRECIP", "PRECIPITATION", "WIND", "VISIBILITY"], ["", "SUNSET", "TEMPERATURE LOW", "TYPE", "HUMIDITY", "GUSTS", "UV INDEX"]]
    
    var hourlyConditions = [Conditions]()
    var dailyConditions: Conditions?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         formatter.locale = 🇺🇸
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
            switch section {
            case 0:
                return tripDetailsHeaders.count
            case 1:
                return 1
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
                let cell = tableView.dequeueReusableCell(withIdentifier: "tripDetailsCell")!
                cell.textLabel?.text = tripDetailsHeaders[indexPath.row]
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! WeatherTableViewCell
                
                let leftHeader = weatherDetailHeaders[0][indexPath.row]
                let rightHeader = weatherDetailHeaders[1][indexPath.row]
                let leftSubtext = weatherDetailString(from: leftHeader, using: dailyConditions)
                let rightSubtext = weatherDetailString(from: rightHeader, using: dailyConditions)
                cell.setUpCell(leftHeader: leftHeader, leftSubtext: leftSubtext, rightHeader: rightHeader, rightSubtext: rightSubtext)
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
}
