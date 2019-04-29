//
//  SettingsViewController.swift
//  Mom
//
//  Created by Aidan Barr Bono (student LM) on 3/28/19.
//  Copyright © 2019 Duck Inc. All rights reserved.
//
import UIKit

class SettingsViewController: UIViewController, ThemedViewController {
    
    // computer property to enclose UserDefaults
    static var isDarkTheme: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "DarkTheme")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "DarkTheme")
        }
    }
    
    // labels
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var notificationSettingsLabel: UILabel!
    @IBOutlet weak var alertMeBeforeAnEventLabel: UILabel!
    @IBOutlet weak var snoozeTimeLabel: UILabel!
    
    // buttons
    @IBOutlet weak var lightThemeButton: UIButton!
    @IBOutlet weak var darkThemeButton: UIButton!
    @IBOutlet weak var syncWithBlackboardButton: UIButton!
    @IBOutlet weak var syncWithPowerschoolButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    
    // implement ThemedViewController
    var backView: UIView { return self.view }
    var navBar: UINavigationBar { return self.navigationController!.navigationBar }
    var labels: [UILabel]? {
        return [themeLabel, notificationSettingsLabel, alertMeBeforeAnEventLabel, snoozeTimeLabel]
    }
    var buttons: [UIButton]? {
        return [lightThemeButton, darkThemeButton, syncWithBlackboardButton, syncWithPowerschoolButton, applyButton]
    }
    var textFields: [UITextField]? {
        return [alertTimeBeforeTextField, snoozeTimeTextField]
    }
    
    func theme(isDarkTheme: Bool) {
        self.defaultTheme(isDarkTheme: isDarkTheme)
    }
    
    // variable to check if changes have been made to settings
    var hasBeenChanged = false
    
    @IBOutlet weak var alertTimeBeforeTextField: UITextField!
    @IBOutlet weak var snoozeTimeTextField: UITextField!
    
    var notificationTimeBeforeDatePicker : UIDatePicker?
    var snoozeTimeDatePicker : UIDatePicker?
    
    // switch stores if the user would like to be notified at all before an event
    @IBOutlet weak var alertBeforeSwitch: UISwitch!
    @IBAction func alertBeforeValueChanged(_ sender: UISwitch) {
        if alertBeforeSwitch.isOn {
            alertTimeBeforeTextField.isEnabled = true
        } else {
            alertTimeBeforeTextField.text = "None"
            alertTimeBeforeTextField.isEnabled = false
        }
    }
    
    // switch to light theme
    @IBAction func lightThemeTouchedUp(_ sender: UIButton) {
        if SettingsViewController.isDarkTheme {
            // change current view as a preview of the theme
            SettingsViewController.isDarkTheme = false
            theme(isDarkTheme: SettingsViewController.isDarkTheme)
        }
    }
    
    // switch to dark theme
    @IBAction func darkThemeTouchedUp(_ sender: UIButton) {
        if !SettingsViewController.isDarkTheme {
            // change current view as a preview of the theme
            SettingsViewController.isDarkTheme = true
            theme(isDarkTheme: SettingsViewController.isDarkTheme)
        }
    }
    
    // segue to Blackboard VC to sync
    @IBAction func syncWithBlackboardButtonTouchedUp(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toBlackboard", sender: self)
    }
    // segue to Powerschool VC to sync
    @IBAction func syncWithPowerschoolButtonTouchedUp(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toPowerschool", sender: self)
    }
    
    // functionality got moved to a more general function
    @IBAction func applyButtonTouchedUp(_ sender: UIButton) {
        saveChanges()
    }
    
    func saveChanges() {
        // if no changes, leave function
        if !hasBeenChanged { return }
        
        // if they want notifications off
        if !alertBeforeSwitch.isOn {
            Notifications.reminderDateComponents = nil
        } else {
            // otherwise save
            let dateComponents = Calendar.current.dateComponents([.minute, .hour], from: (notificationTimeBeforeDatePicker?.date)!)
            Notifications.reminderDateComponents = dateComponents
        }
        // save snooze time
        let snoozeComponents = Calendar.current.dateComponents([.minute], from: (snoozeTimeDatePicker?.date)!)
        Notifications.snoozeTime = snoozeComponents.minute!
        
        // create and present alert
        // this alert asks the user if they would like to redo notifications for previous events
        // with the new reminder time
        let alertController = UIAlertController(title: "Edit current notifications", message: "Would you like to change notification timers for already created events?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Change", style: .default) { (action) in
            Notifications.redoNotifications()
        }
        let denyAction = UIAlertAction(title: "Keep", style: .default, handler: nil)
        
        alertController.addAction(denyAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpSnoozeTimeDatePicker()
        setUpNotificationDatePicker()
        
        // used to exit editing from date pickers
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        theme(isDarkTheme: SettingsViewController.isDarkTheme)
        
        // set top title
        navBar.topItem?.title = "Settings"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // sets text fields to displace correct information
        resetNotificationDatePicker()
        resetSnoozeTimeDatePicker()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // when the view has been presented, no changes have been made
        hasBeenChanged = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // if there are no new changes leave
        if !hasBeenChanged { return }
        
        // create and present "save changes" alert
        let alertController = UIAlertController(title: "Save Changes?", message: nil, preferredStyle: .alert)

        let leaveAction = UIAlertAction(title: "Leave", style: .destructive) { (action) in
            
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            self.saveChanges()
        }

        alertController.addAction(saveAction)
        alertController.addAction(leaveAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    // makes the viewTapped gesture exit editing
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // set up defaults for date picker
    func setUpNotificationDatePicker() {
        notificationTimeBeforeDatePicker = UIDatePicker()
        notificationTimeBeforeDatePicker?.datePickerMode = .countDownTimer
        notificationTimeBeforeDatePicker?.minuteInterval = 5
        
        resetNotificationDatePicker()
        
        // add date changed action
        notificationTimeBeforeDatePicker?.addTarget(self, action: #selector(self.dateChanged(datePicker:)), for: .valueChanged)
        alertTimeBeforeTextField.inputView = notificationTimeBeforeDatePicker
        
    }
    
    // update text field
    func resetNotificationDatePicker() {
        if let components = Notifications.reminderDateComponents {
            if let startDate = Calendar.current.date(from: components) {
                notificationTimeBeforeDatePicker?.setDate(startDate, animated: false)
            }
            alertTimeBeforeTextField.text = "\(components.hour ?? 0) hours and \(components.minute ?? 0) minutes"
        } else {
            alertTimeBeforeTextField.text = "None"
        }
    }
    
    // set up defaults for date picker
    func setUpSnoozeTimeDatePicker() {
        snoozeTimeDatePicker = UIDatePicker()
        snoozeTimeDatePicker?.datePickerMode = .countDownTimer

        resetSnoozeTimeDatePicker()
        
        // add date changed action
        snoozeTimeDatePicker?.addTarget(self, action: #selector(self.dateChanged(datePicker:)), for: .valueChanged)
        snoozeTimeTextField.inputView = snoozeTimeDatePicker
    }
    
    // update text field
    func resetSnoozeTimeDatePicker() {
        if let startDate = Calendar.current.date(from: DateComponents(minute: Notifications.snoozeTime)) {
            snoozeTimeDatePicker?.setDate(startDate, animated: false)
        }
        snoozeTimeTextField.text = "\(Notifications.snoozeTime) minutes"
    }
    
    // called whenever a date is changed in either date picker
    // updates the text field
    @objc func dateChanged(datePicker: UIDatePicker) {
        if datePicker == self.notificationTimeBeforeDatePicker {
            let dateComponents = Calendar.current.dateComponents([.minute, .hour], from: datePicker.date)
            alertTimeBeforeTextField.text = "\(dateComponents.hour ?? 0) hours and \(dateComponents.minute ?? 0) minutes"
        } else if datePicker == self.snoozeTimeDatePicker {
            let dateComponents = Calendar.current.dateComponents([.minute], from: datePicker.date)
            snoozeTimeTextField.text = "\(dateComponents.minute ?? 0) minutes"
        }
        // update
        hasBeenChanged = true
    }
}
