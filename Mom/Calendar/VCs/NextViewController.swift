//
//  NextViewController.swift
//  Mom
//
//  Created by Connor Stange (student LM) on 1/29/19.
//  Copyright © 2019 Duck Inc. All rights reserved.

import UIKit
var time = ""
var subj = ""
var desc = ""

class NextViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ThemedViewController {
    
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet var Table: UITableView!
    @IBOutlet weak var newEventButton: UIButton!
    // Themed View Controller
    var backView: UIView { return self.view }
    var navBar: UINavigationBar { return self.navigationController!.navigationBar }
    var labels: [UILabel]? {
        return [DateLabel]
    }
    var buttons: [UIButton]? {
        return [newEventButton]
    }
    var textFields: [UITextField]? { return nil }
    var tableCellColor: UIColor = UIColor.clear
    var tableCellTextColor: UIColor = UIColor.black
    var events: [Event] = []
    var cellsArray: [UITableViewCell] = []
    
    // Creates a table for the events of the given day
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DateLabel.text = dateString
        if let loadedData = defaults.data(forKey: "\(dateString)*1") {
            if let loadedEvents = NSKeyedUnarchiver.unarchiveObject(with: loadedData) as? [Event] {
                events = loadedEvents
            }
        }
        if let loadedData = defaults.data(forKey: "\(dateString)*2") {
            if let loadedEvents = NSKeyedUnarchiver.unarchiveObject(with: loadedData) as? [Event] {
                for x in loadedEvents{
                    events.append(x)
                }
            }
        }
        if events.count > 0{
            events = order(e: events)
        }
        self.Reload()
        theme(isDarkTheme: SettingsViewController.isDarkTheme)
        Table.reloadData()
    }
    
    // Creates individual sections in order to better distance events
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Distances events
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    // Creates sections based on number of events
    func numberOfSections(in tableView: UITableView) -> Int {
        return events.count
    }
    
    // Colors the tableview
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let newView =  UIView()
        newView.backgroundColor = tableCellColor
        return newView
    }
    
    // Colors cells
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 1
        cell.backgroundColor = UIColor.myPurple
    }
    
    // Creates cells with a date and a subject based on an event
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Table", for: indexPath) as! EventTableViewCell
        cell.Date.text = getTime(s: events[indexPath.section].d.description)
        cell.Date.textColor = tableCellTextColor
        cell.Subject.text = events[indexPath.section].subject
        cell.Subject.textColor = tableCellTextColor
        cell.layer.cornerRadius = 5
        cell.separatorInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        cell.layoutSubviews()
        cellsArray.append(cell)
        return cell
    }
    
    // Creates a segue to DescriptionViewController to see everything about the event
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        time = getTime(s: events[indexPath.section].d.description)
        subj = events[indexPath.section].subject
        desc = events[indexPath.section].information
        performSegue(withIdentifier: "Description", sender: self)
    }
    
    // Reloads the events
    func Reload(){
        events = []
        if let loadedData = defaults.data(forKey: "\(dateString)*1") {
            if let loadedEvents = NSKeyedUnarchiver.unarchiveObject(with: loadedData) as? [Event] {
                events = loadedEvents
            }
        }
        if let loadedData = defaults.data(forKey: "\(dateString)*2") {
            if let loadedEvents = NSKeyedUnarchiver.unarchiveObject(with: loadedData) as? [Event] {
                for x in loadedEvents{
                    events.append(x)
                }
            }
        }
        if events.count > 0{
            events = order(e: events)
        }
        Table.reloadData()
    }
    
    // Func: getTime
    // Input: String Date ("mm/dd/yyyy")
    // Output: Time representive of input
    func getTime(s: String) -> String{
        let returnStr: String
        var time = s[s.firstIndex(of: ":")!...s.lastIndex(of: ":")!]
        time.remove(at: time.lastIndex(of: ":")!)
        var hour = s[s.firstIndex(of: " ")!...s.firstIndex(of: ":")!]
        hour.remove(at: hour.firstIndex(of: " ")!)
        hour.remove(at: hour.firstIndex(of: ":")!)
        var hours = Int(hour)!
        if hours >= 16{
            hours = hours-16
            if hours == 0{ returnStr = "12\(time) PM" }
            else if hours >= 10{ returnStr = "\(hours)\(time) PM" }
            else{ returnStr = " \(hours)\(time) PM" }
        }
        else{
            hours = hours-4
            if hours == 0{ returnStr = "12\(time) AM" }
            else if hours >= 10{ returnStr = "\(hours)\(time) AM" }
            else{ returnStr = "\(hours)\(time) AM" }
        }
        return returnStr
    }
    
    // Func: order
    // Input: Array of Events
    // Output: Array of Events ordered by time
    func order(e: [Event]) -> [Event]{
        var eventz = e
        var returnEvents: [Event] = []
        var next: Event = Event()
        var index: Int = 0
        var lowest = 2500
        var str1: String
        var str2: Substring
        for _ in 0...eventz.count-1{
            for event in eventz{
                str1 = "\(event.d.description)"
                str2 = str1[str1.firstIndex(of: " ")!...str1.lastIndex(of: ":")!]
                str2.remove(at: str2.firstIndex(of: " ")!)
                str2.remove(at: str2.firstIndex(of: ":")!)
                str2.remove(at: str2.firstIndex(of: ":")!)
                if Int("\(str2)")! < lowest{
                    lowest = Int("\(str2)")!
                    next = event
                    index = eventz.firstIndex(of: event)!
                }
            }
            lowest = 2500
            returnEvents.append(next)
            eventz.remove(at: index)
        }
        return returnEvents
    }
    
    // Themes the components of the view
    func theme(isDarkTheme: Bool) {
        defaultTheme(isDarkTheme: isDarkTheme)
        if isDarkTheme {
            Table.backgroundColor = UIColor.myDeepGrey
            tableCellColor = UIColor.myDeepGrey
            tableCellTextColor = UIColor.white
        } else {
            Table.backgroundColor = UIColor.white
            tableCellColor = UIColor.white
            tableCellTextColor = UIColor.black
        }
    }
}
