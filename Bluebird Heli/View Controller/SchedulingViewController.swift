//
//  SchedulingViewController.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 11/21/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import UIKit
import JTAppleCalendar

class SchedulingViewController: UIViewController {
    @IBOutlet var locationButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var calendarView: JTAppleCalendarView!

    var hourlyConditions = [Conditions]()
    var dailyConditions = Conditions()
    
    let numberFormatter = NumberFormatter()
    let formatter = DateFormatter()
    
    let weekendTextColor = UIColor.gray
    let weekdayTextColor = UIColor.black
    let currentDayTextColor = UIColor.red
    let selectedDateTextColor = UIColor.blue
    let outsideMonthColor = UIColor.clear
    let currentDateSelectedViewColor = UIColor.purple
    
    let reserveButton = UIBarButtonItem(title: "Reserve", style: .plain, target: self, action: #selector(reserveTapped))
    
    var weatherDetailHeaders = [["SUMMARY", "SUNRISE", "TEMPERATURE HIGH", "CHANCE OF PRECIP", "PRECIPITATION", "WIND", "VISIBILITY"], ["", "SUNSET", "TEMPERATURE LOW", "TYPE", "HUMIDITY", "GUSTS", "UV INDEX"]]
    
    var selectedLocation = DataStore.shared.centralOperatingArea
  
    override func viewDidLoad() {
        super.viewDidLoad()
       
        hourlyConditions = conditions(for: Date(), for: selectedLocation, conditionType: .hourly)
        setupCalendarView()
        updateUIWeather(for: self.selectedLocation, for: Date())
        self.navigationItem.rightBarButtonItem = reserveButton
        
    }
    
    func setupCalendarView() {
        
        // Scroll to current date and select it
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.selectDates([Date()])
        
        // Set up spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        // Set up labels
        calendarView.visibleDates { (visibleDates) in
            self.setupViewOfCalendar(from: visibleDates)
        }
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? DateCell else { return }
        
        if cellState.isSelected {
            validCell.dateLabel.textColor = selectedDateTextColor
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                if cellState.date.isToday() {
                    validCell.dateLabel.textColor = currentDayTextColor
                } else if cellState.date.isWeekend() {
                    validCell.dateLabel.textColor = weekendTextColor
                } else {
                    validCell.dateLabel.textColor = weekdayTextColor
                }
            } else {
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? DateCell else { return }
        if validCell.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
    }

    func setupViewOfCalendar(from visibleDates: DateSegmentInfo) {
        if let date = visibleDates.monthDates.first?.date {
            formatter.dateFormat = "yyyy"
            self.yearLabel.text = formatter.string(from: date)
            formatter.dateFormat = "MMMM"
            self.monthLabel.text = formatter.string(from: date)
        }
    }
    
}

// MARK: - IBAction
extension SchedulingViewController {
    @IBAction func locationTapped(_ sender: UIButton) {
        selectLocationAlert()
    }
}

// MARK: - JTappleCalendarViewDataSource
extension SchedulingViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let startDate = Date()
        let endDate = Date().addingTimeInterval(31536000)
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
}

// MARK: - JTAppleCalendarViewDelegate
extension SchedulingViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        
        if cellState.dateBelongsTo == .thisMonth {
            if date > Date() || date.isToday() {
                return true
            }
            return false
        } else {
            return false
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let dateCell = cell as! DateCell
        dateCell.dateLabel.text = cellState.text
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        self.hourlyConditions = conditions(for: date, for: selectedLocation, conditionType: .hourly)
        updateUIWeather(for: selectedLocation, for: date)
        self.collectionView.reloadData()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewOfCalendar(from: visibleDates)
    }
    
}

// MARK: - UICollectionViewDataSource
extension SchedulingViewController: UICollectionViewDataSource {
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

// MARK: - UITableViewDataSource
extension SchedulingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDetailHeaders[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! WeatherTableViewCell
      
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension SchedulingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

// MARK: - Helper
extension SchedulingViewController {
    
    func weatherDetailString(from header: String, using conditions: Conditions) -> String {
        switch header {
        case "SUMMARY":
            return conditions.summary
        case "SUNRISE":
            formatter.dateFormat = "h:mm a"
            return formatter.string(from: conditions.sunriseTime)
        default:
            <#code#>
        }
        
        /*
 ["SUMMARY", "SUNRISE", "TEMPERATURE HIGH", "CHANCE OF PRECIP", "PRECIPITATION", "WIND", "VISIBILITY"], ["", "SUNSET", "TEMPERATURE LOW", "TYPE", "HUMIDITY", "GUSTS", "UV INDEX"]
 
 */
    }
    
    func selectLocationAlert() {
        let alert = UIAlertController(title: "Select Location", message: nil, preferredStyle: .actionSheet)
        let northernAreaAction = UIAlertAction(title: "Northern Operating Area", style: .default) { (action) in
            self.selectedLocation = DataStore.shared.northerOperatingArea
            self.collectionView.reloadData()
            if let date = self.calendarView.selectedDates.first {
                self.updateUIWeather(for: self.selectedLocation, for: date)
            }
        }
        let centralAreaAction = UIAlertAction(title: "Central Operating Area", style: .default) { (action) in
            self.selectedLocation = DataStore.shared.centralOperatingArea
            self.collectionView.reloadData()
            if let date = self.calendarView.selectedDates.first {
                self.updateUIWeather(for: self.selectedLocation, for: date)
            }
        }
        let southernAreaAction = UIAlertAction(title: "Southern Operating Area", style: .default) { (action) in
            self.selectedLocation = DataStore.shared.southernOperatingArea
            self.collectionView.reloadData()
            if let date = self.calendarView.selectedDates.first {
                self.updateUIWeather(for: self.selectedLocation, for: date)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(northernAreaAction)
        alert.addAction(centralAreaAction)
        alert.addAction(southernAreaAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateUIWeather(for location: Location, for date: Date) {
        self.locationButton.setTitle(self.selectedLocation.name, for: .normal)
     
    }

    func conditions(for date: Date, for location: Location, conditionType: ConditionType) -> [Conditions] {
        var conditionsToFilter = [Conditions]()
        switch conditionType {
        case .daily:
            conditionsToFilter = location.weather.daily
        case .hourly:
            conditionsToFilter = location.weather.hourly
        default:
            break
        }
        
        return conditionsToFilter.filter({$0.time.timeIntervalSince1970 >= date.startInterval() && $0.time.timeIntervalSince1970 <= date.endInterval()})
    }
    
    @objc func reserveTapped() {
        
    }
}

