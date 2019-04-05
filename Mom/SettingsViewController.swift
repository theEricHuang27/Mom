//
//  SettingsViewController.swift
//  Mom
//
//  Created by Aidan Barr Bono (student LM) on 3/28/19.
//  Copyright © 2019 Duck Inc. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var alertTimeBeforeTextField: UITextField!
    @IBOutlet weak var snoozeTimeTextField: UITextField!
    var notificationTimeBeforeDatePicker : UIDatePicker?
    var snoozeTimeDatePicker : UIDatePicker?
    
    @IBAction func applyButtonTouchedUp(_ sender: UIButton) {
        // put the time into the user defaults thing
        // this is like a lame substitute for now
        let dateComponents = Calendar.current.dateComponents([.minute, .hour], from: (notificationTimeBeforeDatePicker?.date)!)
        Notifications.reminderDateComponents = dateComponents

        let alertController = UIAlertController(title: "Edit current notifications", message: "Would you like to change notification timers for already created events?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Change", style: .default) { (action) in
            Notifications.redoNotifications()
        }
        let denyAction = UIAlertAction(title: "Keep", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(denyAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpSnoozeTimeDatePicker()
        setUpNotificationDatePicker()
    }
    
    func setUpNotificationDatePicker() {
        notificationTimeBeforeDatePicker = UIDatePicker()
        notificationTimeBeforeDatePicker?.datePickerMode = .countDownTimer
        notificationTimeBeforeDatePicker?.minuteInterval = 5
        if let components = Notifications.reminderDateComponents {
            if let startDate = Calendar.current.date(from: components) {
                notificationTimeBeforeDatePicker?.setDate(startDate, animated: false)
            }
        }
        
        notificationTimeBeforeDatePicker?.addTarget(self, action: #selector(self.dateChanged(datePicker:)), for: .valueChanged)
        alertTimeBeforeTextField.inputView = notificationTimeBeforeDatePicker
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateComponents = Calendar.current.dateComponents([.minute, .hour], from: (notificationTimeBeforeDatePicker?.date)!)
        alertTimeBeforeTextField.text = "\(dateComponents.hour ?? 0) hours and \(dateComponents.minute ?? 0) minutes."
    }
    
    func setUpSnoozeTimeDatePicker() {
        snoozeTimeDatePicker = UIDatePicker()
        snoozeTimeDatePicker?.datePickerMode = .countDownTimer
        if let startDate = Calendar.current.date(from: DateComponents(minute: Int(Notifications.snoozeTime))) {
            snoozeTimeDatePicker?.setDate(startDate, animated: false)
        }
    }
}
