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
    var pickerViewData = ["Heber", "Other One"]
    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPickerView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    @IBAction func backTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        locationTextField.inputView = pickerView
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
        
        
        
    }
    
}

extension ReservationViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case pickupTimeTextField:
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .time
            textField.inputView = datePicker
            datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        default:
            break
            
            
        }
    }
    

    
}

// MARK: - Helper
extension ReservationViewController {
    @objc func datePickerChanged(sender: UIDatePicker) {
        
    }
}
