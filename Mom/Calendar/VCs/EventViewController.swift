//
//  EventViewController.swift
//  Mom
//
//  Created by Connor Stange (student LM) on 2/19/19.
//  Copyright © 2019 Duck Inc. All rights reserved.

import UIKit

class EventViewController: UIViewController, UITextFieldDelegate, ThemedViewController {
    
    @IBOutlet var SubjectTextField: UITextField!
    @IBOutlet var DatePicker: UIDatePicker!
    @IBOutlet var InformationTextField: UITextField!
    @IBOutlet var CreateEventButton: UIButton!
    @IBOutlet var dateChooser: UIDatePicker!
    var events: [Event] = []
    // Themed View Controller
    var backView: UIView { return self.view }
    var navBar: UINavigationBar { return self.navigationController!.navigationBar }
    var labels: [UILabel]? {
        return nil
    }
    var buttons: [UIButton]? {
        return [CreateEventButton]
    }
    var textFields: [UITextField]? {
        return [InformationTextField, SubjectTextField]
    }
    
    // Loads the components for creating a new event
    override func viewDidLoad() {
        super.viewDidLoad()
        SubjectTextField.delegate = self
        InformationTextField.delegate = self
        SubjectTextField.becomeFirstResponder()
        dateChooser.setDate(getDate(s: dateString), animated: false)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    // Sets the theme
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        theme(isDarkTheme: SettingsViewController.isDarkTheme)
    }
    
    // Allows user to tap out of text fields
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // Creates an event using the user defined components
    @IBAction func CreateEvent(_ sender: UIButton) {
        guard let subject = SubjectTextField.text else {return}
        let d: Date = DatePicker.date
        guard let information = InformationTextField.text else {return}
        if let loadedData = defaults.data(forKey: "\(dateString)*1") {
            if let loadedEvents = NSKeyedUnarchiver.unarchiveObject(with: loadedData) as? [Event] {
                events = loadedEvents
                let event = Event(d: d, subject: subject, information: information)
                Notifications.generateNotificationFrom(event)
                events.append(event)
                let eventData = NSKeyedArchiver.archivedData(withRootObject: events)
                defaults.set(eventData, forKey: "\(dateString)*1")
            }
        }
        else{
            let event = Event(d: d, subject: subject, information: information)
            Notifications.generateNotificationFrom(event)
            events.append(event)
            let eventData = NSKeyedArchiver.archivedData(withRootObject: events)
            defaults.set(eventData, forKey: "\(dateString)*1")
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    // Forces the user to complete an event
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if SubjectTextField.isFirstResponder {
            InformationTextField.becomeFirstResponder()
        }
        else {
            InformationTextField.resignFirstResponder()
            CreateEventButton.isEnabled = true
        }
        return true
    }
    
    // Func: getDate
    // Input: Date
    // Output: String Date ("mm/dd/yyyy") representive of input
    func getDate(d: Date) -> String{
        let d = "\(d.description[...(d.description).firstIndex(of: " ")!])"
        var month = d[d.firstIndex(of: "-")!...d.lastIndex(of: "-")!]
        month.remove(at: month.firstIndex(of: "-")!)
        month.remove(at: month.firstIndex(of: "-")!)
        if(Int(month)! < 10){
            month.remove(at: month.firstIndex(of: "0")!)
        }
        var day = "\(d[d.lastIndex(of: "-")!...])"
        day.remove(at: day.firstIndex(of: "-")!)
        day.remove(at: day.firstIndex(of: " ")!)
        if(Int(day)! < 10){
            day.remove(at: day.firstIndex(of: "0")!)
        }
        var year = d[...d.firstIndex(of: "-")!]
        year.remove(at: year.firstIndex(of: "-")!)
        return "\(month)/\(day)/\(year)"
    }
    
    // Func: getDate
    // Input: String Date ("mm/dd/yyyy")
    // Output: Date representive of input
    func getDate(s: String) -> Date{
        var month = s[...s.firstIndex(of: "/")!]
        month.remove(at: month.firstIndex(of: "/")!)
        var day = s[s.firstIndex(of: "/")!...s.lastIndex(of: "/")!]
        day.remove(at: day.firstIndex(of: "/")!)
        day.remove(at: day.firstIndex(of: "/")!)
        var year = s[s.lastIndex(of: "/")!...]
        year.remove(at: year.firstIndex(of: "/")!)
        let d = NSDateComponents()
        d.day = Int(day)!
        d.month = Int(month)!
        d.year = Int(year)!
        d.hour = 7
        d.minute = 30
        d.timeZone = TimeZone(abbreviation: "EST")
        return (NSCalendar(identifier: NSCalendar.Identifier.gregorian)?.date(from: d as DateComponents))!
    }
    
    // Themes the components of the view
    func theme(isDarkTheme: Bool) {
        defaultTheme(isDarkTheme: isDarkTheme)
    }
}
