//
//  ReservationViewController.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 12/6/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import UIKit

class ReservationViewController: UIViewController {

    @IBOutlet var pickupLocationButton: UIButton!
    @IBOutlet var pickupTimeButton: UIButton!
    @IBOutlet var numberOfGuestsButton: UIButton!
    @IBOutlet var pickerViewBackground: UIView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var pickerView: UIPickerView!
    
    var pickerViewData: [String] = []
    var selectedDay = Day()
    var reservation = Reservation()
    var propertyBeingChanged = ""
    
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUIWithExistingReservation()
        setUpPickerView()
        setGradients()
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveReservation))
        navigationItem.rightBarButtonItem = saveButton
        formatter.dateFormat = "h:mm a"
        let tap = UITapGestureRecognizer(target: self, action: #selector(hidePickerView))
        self.view.addGestureRecognizer(tap)
        reservation.groupUID = DataStore.shared.currentGroup?.uid
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
}

extension ReservationViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData.count
    }
    
}

extension ReservationViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let title = pickerViewData[row]
        switch propertyBeingChanged {
        case "Pickup Location":
            reservation.pickupLocation = PickupLocation(rawValue: pickerViewData[row])
            pickupLocationButton.setTitle(title, for: .normal)
        case "Pickup Time":
            print(title)
            formatter.dateFormat = "h:mm a"
            guard let date = formatter.date(from: title) else { return }
            reservation.pickupTime = formatter.date(from: pickerViewData[row])
            formatter.dateFormat = "EEEE, MMM d, h:mm a"
            pickupTimeButton.setTitle(formatter.string(from: date), for: .normal)
            switch segmentedControl.selectedSegmentIndex {
            case 0: reservation.timeSlot = .AM
            case 1: reservation.timeSlot = .PM
            default: break
            }
        case "Group Size":
            reservation.numberOfAttendees = Int(pickerViewData[row])
            numberOfGuestsButton.setTitle(title, for: .normal)
        default:
            break
        }
    }
    
}

// MARK: - @IBAction
extension ReservationViewController {
    
    @IBAction func saveTapped(_ sender: UIButton) {
        saveReservation()
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Helper
extension ReservationViewController {
    
    @objc func hidePickerView() {
        pickerViewBackground.isHidden = true
        segmentedControl.isHidden = true
    }
    
    func setGradients() {
        setGradient(for: pickupLocationButton)
        setGradient(for: pickupTimeButton)
        setGradient(for: numberOfGuestsButton)
    }
    
    func setGradient(for button: UIButton) {
        button.setGradientBackground(colors: [Colors.translucentDarkerGray.cgColor, Colors.translucentDarkGray.cgColor, Colors.translucentDarkerGray.cgColor])
    }
    
    @objc func saveReservation() {
        guard reservation.initialized() else {
            print("Reservation not saved, Reservation not initialized RVC")
            return
        }
        if selectedDay.reservationOne == nil {
            selectedDay.reservationOne = reservation
        } else if selectedDay.reservationTwo == nil {
            selectedDay.reservationTwo = reservation
        } else {
            print("Reservation not saved, Selected Day full")
            return
        }
        DataStore.shared.daysDict[selectedDay.urlDateString()] = selectedDay
        selectedDay.save()
        dismiss(animated: true, completion: nil)
    }
    
    func setPickerViewData() {
        switch propertyBeingChanged {
        case "Pickup Location":
            pickerViewData = [PickupLocation.northSaltLake.rawValue, PickupLocation.heber.rawValue]
        case "Pickup Time":
            pickerViewData = availablePickupTimes()
        case "Group Size":
            pickerViewData = ["1", "2", "3", "4", "5", "6", "7", "8"]
        default:
            break
        }
    }
    
    func availablePickupTimes() -> [String] {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return amSlots()
        case 1:
            return pmSlots()
        default:
            break
        }
        return [""]
    }
  
    func amSlots() -> [String] {
        var retVal = [String]()
        formatter.dateFormat = "h:mm a"
        guard var startTime = formatter.date(from: "9:00 AM") else { return [] }
        if let reservation = selectedDay.reservationOne, let pickupTime = reservation.pickupTime {
            while startTime.addingTimeInterval(60 * 60 * 2) <= pickupTime {
                retVal.append(formatter.string(from: startTime))
                startTime = startTime.addingTimeInterval(900)
            }
        } else {
            for _ in 0...12 {
                retVal.append(formatter.string(from: startTime))
                // add 15 minutes
                startTime = startTime.addingTimeInterval(900)
            }
        }
        return retVal
    }
    
    func pmSlots() -> [String] {
        var retVal = [String]()
        formatter.dateFormat = "h:mm a"
        guard var startTime = formatter.date(from: "1:00 PM") else { return [] }
        if let reservation = selectedDay.reservationOne, let pickupTime = reservation.pickupTime {
            if pickupTime.addingTimeInterval(60 * 60 * 2) >= startTime {
                startTime = pickupTime.addingTimeInterval(60 * 60 * 2)
                if let latestPickupTime = formatter.date(from: "3:00 PM") {
                    while startTime < latestPickupTime {
                        retVal.append(formatter.string(from: startTime))
                        startTime = startTime.addingTimeInterval(900)
                    }
                }
            }
        } else {
            for _ in 0...8 {
                retVal.append(formatter.string(from: startTime))
                // add 15 minutes
                startTime = startTime.addingTimeInterval(900)
            }
        }
        return retVal
    }
    
    func setUpUIWithExistingReservation() {
        guard let reservation = selectedDay.reservationOne else { return }
        if reservation.timeSlot == .AM {
            segmentedControl.selectedSegmentIndex = 1
            segmentedControl.isUserInteractionEnabled = false
        } else {
            segmentedControl.selectedSegmentIndex = 0
            segmentedControl.isUserInteractionEnabled = false
        }
    }
    
}

// MARK: - @IBAction
extension ReservationViewController {
    
    @IBAction func segmentedControlTapped(_ sender: UISegmentedControl) {
        setPickerViewData()
        pickerView.reloadAllComponents()
    }
    
    @IBAction func pickupLocationTapped(_ sender: UIButton) {
        propertyBeingChanged = "Pickup Location"
        setPickerViewData()
        pickerView.reloadAllComponents()
        pickerViewBackground.isHidden = false
        segmentedControl.isHidden = true
    }
    
    @IBAction func pickupTimeTapped(_ sender: UIButton) {
        propertyBeingChanged = "Pickup Time"
        setPickerViewData()
        pickerView.reloadAllComponents()
        pickerViewBackground.isHidden = false
        segmentedControl.isHidden = false
    }
    
    @IBAction func groupSizeTapped(_ sender: UIButton) {
        propertyBeingChanged = "Group Size"
        setPickerViewData()
        pickerView.reloadAllComponents()
        pickerViewBackground.isHidden = false
        segmentedControl.isHidden = true
    }
    
}

