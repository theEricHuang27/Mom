//
//  DescriptionViewController.swift
//  Mom
//
//  Created by Connor Stange (student LM) on 4/9/19.
//  Copyright © 2019 Duck Inc. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController, ThemedViewController {

    @IBOutlet var Subject: UILabel!
    @IBOutlet var Day: UILabel!
    @IBOutlet var Description: UITextView!
    var events: [Event] = []
    @IBOutlet var deleteButton: UIButton!
    // Themed View Controller
    var backView: UIView { return self.view }
    var navBar: UINavigationBar { return self.navigationController!.navigationBar }
    var labels: [UILabel]? {
        return [Subject, Day]
    }
    var buttons: [UIButton]? { return [deleteButton] }
    var textFields: [UITextField]? { return nil }
    func theme(isDarkTheme: Bool) {
        defaultTheme(isDarkTheme: isDarkTheme)
        if isDarkTheme {
            Description.textColor = UIColor.white
            Description.backgroundColor = UIColor.myDeepGrey
        } else {
            Description.textColor = UIColor.black
            Description.backgroundColor = UIColor.white
        }
    }
    
    // Displays every component of the event
    override func viewDidLoad() {
        super.viewDidLoad()
        Subject.text = subj
        Day.text = "\(dateString) @ \(time)"
        let htmlString = desc
        let htmlData = NSString(string: htmlString).data(using: String.Encoding.unicode.rawValue)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        let attributedString = try! NSAttributedString(data: htmlData!, options: options, documentAttributes: nil)
        Description.attributedText = attributedString
        Description.font = UIFont(descriptor: UIFontDescriptor(name: "Open Sans", size: 20), size: 20)
    }
    
    // Sets the theme
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        theme(isDarkTheme: SettingsViewController.isDarkTheme)
    }
    
    // Deletes the event
    @IBAction func deleteEvent(_ sender: UIButton) {
        var a = 0
        if let loadedData = defaults.data(forKey: "\(dateString)*1") {
            if let loadedEvents = NSKeyedUnarchiver.unarchiveObject(with: loadedData) as? [Event] {
                events = loadedEvents
            }
        }
        for x in events{
            if x.subject == subj && getTime(s: x.d.description) == time && x.information == desc{
                events.remove(at: a)
                if events == []{
                    defaults.removeObject(forKey: "\(dateString)*1")
                }
                else{
                    let eventData = NSKeyedArchiver.archivedData(withRootObject: events)
                    defaults.set(eventData, forKey: "\(dateString)*1")
                }
            }
            a += 1
        }
        a = 0
        if let loadedData = defaults.data(forKey: "\(dateString)*2") {
            if let loadedEvents = NSKeyedUnarchiver.unarchiveObject(with: loadedData) as? [Event] {
                events = loadedEvents
            }
        }
        for x in events{
            if x.subject == subj && getTime(s: x.d.description) == time && x.information == desc{
                events.remove(at: a)
                if events == []{
                    defaults.removeObject(forKey: "\(dateString)*2")
                }
                else{
                    let eventData = NSKeyedArchiver.archivedData(withRootObject: events)
                    defaults.set(eventData, forKey: "\(dateString)*2")
                }
            }
            a += 1
        }
        _ = navigationController?.popViewController(animated: true)
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
}
