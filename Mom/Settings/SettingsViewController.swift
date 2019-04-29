//
//  SettingsViewController.swift
//  Mom
//
//  Created by Aidan Barr Bono (student LM) on 3/28/19.
//  Copyright © 2019 Duck Inc. All rights reserved.
//
import UIKit

class SettingsViewController: UIViewController, ThemedViewController {
    
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
    
    var hasBeenChanged = false
    
    @IBOutlet weak var alertTimeBeforeTextField: UITextField!
    @IBOutlet weak var snoozeTimeTextField: UITextField!
    var notificationTimeBeforeDatePicker : UIDatePicker?
    var snoozeTimeDatePicker : UIDatePicker?
    
    @IBOutlet weak var alertBeforeSwitch: UISwitch!
    @IBAction func alertBeforeValueChanged(_ sender: UISwitch) {
        if alertBeforeSwitch.isOn {
            alertTimeBeforeTextField.isEnabled = true
        } else {
            alertTimeBeforeTextField.text = "None"
            alertTimeBeforeTextField.isEnabled = false
        }
    }
    
    
    @IBAction func lightThemeTouchedUp(_ sender: UIButton) {
        if SettingsViewController.isDarkTheme {
            // change current view as a preview of the theme
            SettingsViewController.isDarkTheme = false
            theme(isDarkTheme: SettingsViewController.isDarkTheme)
        }
    }
    
    @IBAction func darkThemeTouchedUp(_ sender: UIButton) {
        if !SettingsViewController.isDarkTheme {
            // change current view as a preview of the theme
            SettingsViewController.isDarkTheme = true
            theme(isDarkTheme: SettingsViewController.isDarkTheme)
        }
    }
    @IBAction func syncWithBlackboardButtonTouchedUp(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toBlackboard", sender: self)
    }
    
    @IBAction func syncWithPowerschoolButtonTouchedUp(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toPowerschool", sender: self)
    }
    
    @IBAction func applyButtonTouchedUp(_ sender: UIButton) {
        saveChanges()
    }
    
    func saveChanges() {
        if !hasBeenChanged { return }
        if !alertBeforeSwitch.isOn {
            Notifications.reminderDateComponents = nil
        } else {
            let dateComponents = Calendar.current.dateComponents([.minute, .hour], from: (notificationTimeBeforeDatePicker?.date)!)
            Notifications.reminderDateComponents = dateComponents
        }
        let snoozeComponents = Calendar.current.dateComponents([.minute], from: (snoozeTimeDatePicker?.date)!)
        Notifications.snoozeTime = snoozeComponents.minute!
        
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        theme(isDarkTheme: SettingsViewController.isDarkTheme)
        
        navBar.topItem?.title = "Settings"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetNotificationDatePicker()
        resetSnoozeTimeDatePicker()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        hasBeenChanged = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !hasBeenChanged { return }
        
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
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func setUpNotificationDatePicker() {
        notificationTimeBeforeDatePicker = UIDatePicker()
        notificationTimeBeforeDatePicker?.datePickerMode = .countDownTimer
        notificationTimeBeforeDatePicker?.minuteInterval = 5
        
        resetNotificationDatePicker()
        
        notificationTimeBeforeDatePicker?.addTarget(self, action: #selector(self.dateChanged(datePicker:)), for: .valueChanged)
        alertTimeBeforeTextField.inputView = notificationTimeBeforeDatePicker
        
    }
    
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
    
    func setUpSnoozeTimeDatePicker() {
        snoozeTimeDatePicker = UIDatePicker()
        snoozeTimeDatePicker?.datePickerMode = .countDownTimer

        resetSnoozeTimeDatePicker()
        
        snoozeTimeDatePicker?.addTarget(self, action: #selector(self.dateChanged(datePicker:)), for: .valueChanged)
        snoozeTimeTextField.inputView = snoozeTimeDatePicker
    }
    
    func resetSnoozeTimeDatePicker() {
        if let startDate = Calendar.current.date(from: DateComponents(minute: Notifications.snoozeTime)) {
            snoozeTimeDatePicker?.setDate(startDate, animated: false)
        }
        snoozeTimeTextField.text = "\(Notifications.snoozeTime) minutes"
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        if datePicker == self.notificationTimeBeforeDatePicker {
            let dateComponents = Calendar.current.dateComponents([.minute, .hour], from: datePicker.date)
            alertTimeBeforeTextField.text = "\(dateComponents.hour ?? 0) hours and \(dateComponents.minute ?? 0) minutes"
        } else if datePicker == self.snoozeTimeDatePicker {
            let dateComponents = Calendar.current.dateComponents([.minute], from: datePicker.date)
            snoozeTimeTextField.text = "\(dateComponents.minute ?? 0) minutes"
        }
        hasBeenChanged = true
    }
    
    func theme(isDarkTheme: Bool) {
        self.defaultTheme(isDarkTheme: isDarkTheme)
//        applyButton.layer.cornerRadius = 5
//        applyButton.backgroundColor = UIColor.myPurple
//        syncWithBlackboardButton.setTitleColor(UIColor.myYellow, for: .normal)
//        syncWithBlackboardButton.layer.cornerRadius = 5
//        syncWithBlackboardButton.backgroundColor = UIColor.myPurple
    }
}
