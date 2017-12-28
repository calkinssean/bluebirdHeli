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
    @IBOutlet var datePickerBackground: UIView!
    
    var pickerViewData: [String] = []
    var pickerView = UIPickerView()
    
    var selectedDay = Day()
    var reservation = Reservation()
    var propertyBeingChanged = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPickerView()
        setGradients()
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveReservation))
        navigationItem.rightBarButtonItem = saveButton
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
        self.reservation.pickupTime = sender.date
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
    
    
}

// MARK: - @IBAction
extension ReservationViewController {
    
    @IBAction func pickupLocationTapped(_ sender: UIButton) {
    }
    
    @IBAction func pickupTimeTapped(_ sender: UIButton) {
    }
    
    @IBAction func groupSizeTapped(_ sender: UIButton) {
    }
    
}

// MARK: - Helper
extension ReservationViewController {
    
    func setGradients() {
        setGradient(for: pickupLocationButton)
        setGradient(for: pickupTimeButton)
        setGradient(for: numberOfGuestsButton)
    }
    
    func setGradient(for button: UIButton) {
        button.setGradientBackground(colors: [Colors.translucentDarkerGray.cgColor, Colors.translucentDarkGray.cgColor, Colors.translucentDarkerGray.cgColor])
    }
    
}
