//
//  ReservationViewController.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 12/6/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import UIKit

class ReservationViewController: UIViewController {

    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var pickupTimeTextField: UITextField!
    @IBOutlet var numberOfPeopleTextField: UITextField!
    
    var currentTextField = UITextField()
    var pickerViewData: [String] = []
    var pickerView = UIPickerView()
    
    var selectedDay = Day()
    var reservation = Reservation()
    var propertyBeingChanged = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPickerView()
        
        reservation.groupUID = DataStore.shared.currentGroup?.uid
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
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
        self.currentTextField.text = pickerViewData[row]
        switch propertyBeingChanged {
        case "Pickup Location":
            reservation.pickupLocation = PickupLocation(rawValue: pickerViewData[row])
        case "Number Of People":
            reservation.numberOfAttendees = Int(pickerViewData[row])
        default:
            break
        }
    }
    
}

extension ReservationViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case locationTextField:
            self.pickerViewData = [PickupLocation.heber.rawValue, PickupLocation.northSaltLake.rawValue]
            self.pickerView.reloadAllComponents()
            textField.inputView = pickerView
            currentTextField = textField
            propertyBeingChanged = "Pickup Location"
        case pickupTimeTextField:
            let datePicker = UIDatePicker()
            datePicker.setDate(selectedDay.date, animated: false)
            datePicker.datePickerMode = .time
            datePicker.minuteInterval = 15
            textField.inputView = datePicker
            datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        case numberOfPeopleTextField:
            self.pickerViewData = ["1", "2", "3", "4", "5", "6", "7", "8"]
            self.pickerView.reloadAllComponents()
            textField.inputView = pickerView
            currentTextField = textField
            propertyBeingChanged = "Number Of People"
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
    
    @objc func datePickerChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM dd - hh:mm a"
        self.pickupTimeTextField.text = dateFormatter.string(from: sender.date)
        self.reservation.pickupTime = sender.date
    }
    
    @objc func dismissKeyboard() {
        self.locationTextField.resignFirstResponder()
        self.pickupTimeTextField.resignFirstResponder()
        self.numberOfPeopleTextField.resignFirstResponder()
    }
    
    func saveReservation() {
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
    
    
}
