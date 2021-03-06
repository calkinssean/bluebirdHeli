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
    
    @IBOutlet var calendarBackground: UIView!
    @IBOutlet var locationButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var noDataLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var calendarView: JTAppleCalendarView!

    var hourlyConditions = [Conditions]()
    var dailyConditions: Conditions?
    
    var selectedLocation: Location?
    var selectedDay = Day()
    
    let numberFormatter = NumberFormatter()
    let formatter = DateFormatter()
    let measurementFormatter = MeasurementFormatter()
    let 🇺🇸 = Locale(identifier: "en_US")
    
    let weekendTextColor = UIColor.gray
    let weekdayTextColor = UIColor.white
    
    let weatherDetailHeaders = [["SUMMARY", "SUNRISE", "TEMPERATURE HIGH", "CHANCE OF PRECIP", "PRECIPITATION", "WIND", "VISIBILITY"], ["", "SUNSET", "TEMPERATURE LOW", "TYPE", "HUMIDITY", "GUSTS", "UV INDEX"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.locale = 🇺🇸
        setupCalendarView()
    
        tableView.tableFooterView = UIView()
        
        let reserveButton = UIBarButtonItem(title: "Reserve", style: .plain, target: self, action: #selector(reserveTapped))
        self.navigationItem.rightBarButtonItem = reserveButton
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedLocation != nil {
            setReserveButtonEnabled(enabled: false)
            calendarView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setBackgroundGradient()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReservationSegue" {
            let destination = segue.destination as! ReservationViewController
            destination.selectedDay = self.selectedDay
            destination.reservation.operatingArea = selectedLocation?.operatingArea
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
        handleCellBorderColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellBorderColor(view: cell, cellState: cellState)
        updateUIWeather(for: selectedLocation, for: date)
        self.selectedDay = DateController().day(from: cellState.date)
        self.collectionView.reloadData()
        if let location = selectedLocation {
            self.setReserveButtonEnabled(enabled: selectedDay.available(with: location))
        } else {
            self.setReserveButtonEnabled(enabled: false)
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellBorderColor(view: cell, cellState: cellState)
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
        
        let leftHeader = weatherDetailHeaders[0][indexPath.row]
        let rightHeader = weatherDetailHeaders[1][indexPath.row]
        let leftSubtext = weatherDetailString(from: leftHeader, using: dailyConditions)
        let rightSubtext = weatherDetailString(from: rightHeader, using: dailyConditions)
        cell.setUpCell(leftHeader: leftHeader, leftSubtext: leftSubtext, rightHeader: rightHeader, rightSubtext: rightSubtext)
        
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
    
    func setBackgroundGradient() {
        calendarBackground.clipsToBounds = true
        calendarBackground.setGradientBackground(colors: [Colors.darkerGray.cgColor, UIColor.darkGray.cgColor])
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
        if cellState.dateBelongsTo == .thisMonth {
            if cellState.date.isWeekend() {
                validCell.dateLabel.textColor = weekendTextColor
            } else {
                validCell.dateLabel.textColor = weekdayTextColor
            }
        } else {
            validCell.dateLabel.textColor = Colors.outsideMonthTextColor
        }
    }
    
    func handleCellBorderColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? DateCell else { return }
        formatter.dateFormat = "yyyy-MM-dd"
        validCell.availabilityView.layer.borderColor = Colors.outsideMonthTextColor.cgColor
        let day = DateController().day(from: cellState.date)
        if cellState.dateBelongsTo == .thisMonth {
            validCell.availabilityView.layer.borderWidth = 2
            validCell.availabilityView.layer.borderColor = color(for: day, cellState: cellState)
        }
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? DateCell else { return }
        if validCell.isSelected {
            validCell.availabilityView.backgroundColor = Colors.selectedDayViewColor
        } else {
            validCell.availabilityView.backgroundColor = UIColor.clear
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

    func selectLocationAlert() {
        let alert = UIAlertController(title: "Select Location", message: nil, preferredStyle: .actionSheet)
        let northernAreaAction = UIAlertAction(title: "Northern Operating Area", style: .default) { (action) in
            self.selectedLocation = DataStore.shared.northernOperatingArea
            if let date = self.calendarView.selectedDates.first {
                self.updateUIWeather(for: self.selectedLocation, for: date)
            }
            self.calendarView.reloadData()
            self.updateReserveButton(with: self.selectedLocation)
        }
        let centralAreaAction = UIAlertAction(title: "Central Operating Area", style: .default) { (action) in
            self.selectedLocation = DataStore.shared.centralOperatingArea
            if let date = self.calendarView.selectedDates.first {
                self.updateUIWeather(for: self.selectedLocation, for: date)
            }
            self.calendarView.reloadData()
            self.updateReserveButton(with: self.selectedLocation)
        }
        let southernAreaAction = UIAlertAction(title: "Southern Operating Area", style: .default) { (action) in
            self.selectedLocation = DataStore.shared.southernOperatingArea
            if let date = self.calendarView.selectedDates.first {
                self.updateUIWeather(for: self.selectedLocation, for: date)
            }
            self.calendarView.reloadData()
            self.updateReserveButton(with: self.selectedLocation)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(northernAreaAction)
        alert.addAction(centralAreaAction)
        alert.addAction(southernAreaAction)
        alert.addAction(cancelAction)
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = view
            popoverController.sourceRect = locationButton.frame
        }
        self.present(alert, animated: true, completion: {
            self.tableView.isHidden = false
        })
    }
    
    func updateUIWeather(for location: Location?, for date: Date) {
        guard let location = location else { return }
        self.locationButton.setTitle(location.operatingArea?.rawValue, for: .normal)
        self.hourlyConditions = WeatherController().conditions(for: date, for: location, conditionType: .hourly)
        if let conditions = WeatherController().conditions(for: date, for: location, conditionType: .daily).first {
            self.noDataLabel.isHidden = true
            dailyConditions = conditions
        } else {
            self.noDataLabel.isHidden = false
            dailyConditions = nil
        }
        self.collectionView.reloadData()
        self.tableView.reloadData()
    }
    
    func color(for day: Day, cellState: CellState) -> CGColor {
    
        guard let location = self.selectedLocation else { return UIColor.clear.cgColor }
        
        let calendar = Calendar.current
        
        if cellState.dateBelongsTo != .thisMonth {
            return UIColor.clear.cgColor
        }
        
        if cellState.date.isToday() {
            return Colors.unavailableViewColor.cgColor
        }
        
        switch calendar.compare(day.date, to: Date(), toGranularity: .month) {
        case .orderedAscending:
            return UIColor.clear.cgColor
        case .orderedSame:
            switch calendar.compare(day.date, to: Date(), toGranularity: .day) {
            case .orderedAscending:
                return UIColor.clear.cgColor
            case .orderedSame:
                if day.available(with: location) {
                    return Colors.availableViewColor.cgColor
                }
            case .orderedDescending:
                guard let dayComp1 = calendar.dateComponents([.day], from: day.date).day, let dayComp2 = calendar.dateComponents([.day], from: Date()).day else {
                    return UIColor.clear.cgColor
                }
                if day.available(with: location) {
                    if dayComp1 <= (dayComp2 + 3) {
                        return Colors.availableViewColor.cgColor
                    } else {
                        return Colors.standbyViewColor.cgColor
                    }
                }
            }
            return Colors.unavailableViewColor.cgColor
        case .orderedDescending:
            
            if day.available(with: location) {
                return Colors.standbyViewColor.cgColor
            }
            return Colors.unavailableViewColor.cgColor
        }
    }
    
    func updateReserveButton(with location: Location?) {
        if let location = location {
            self.setReserveButtonEnabled(enabled: selectedDay.available(with: location))
        }
    }
    
    func setReserveButtonEnabled(enabled: Bool) {
       navigationItem.rightBarButtonItem?.isEnabled = enabled
    }
    
    @objc func reserveTapped() {
        self.performSegue(withIdentifier: "showReservationSegue", sender: self)
    }
    
}

