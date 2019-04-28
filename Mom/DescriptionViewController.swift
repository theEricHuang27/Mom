//
//  DescriptionViewController.swift
//  Mom
//
//  Created by Connor Stange (student LM) on 4/9/19.
//  Copyright © 2019 Duck Inc. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {

    @IBOutlet var Subject: UILabel!
    @IBOutlet var Day: UILabel!
    @IBOutlet var Description: UITextView!
    var events: [Event] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        Subject.text = subj
        Day.text = "\(dateString) @ \(time)"
        let htmlString = desc
        let htmlData = NSString(string: htmlString).data(using: String.Encoding.unicode.rawValue)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        let attributedString = try! NSAttributedString(data: htmlData!, options: options, documentAttributes: nil)
        Description.attributedText = attributedString
        Description.font = UIFont(descriptor: UIFontDescriptor(name: "Helvetica Neue", size: 17), size: 17)
    }
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
    func order(e: [Event]) -> [Event]{
        var z = e
        var new: [Event] = []
        var next: Event = Event()
        var index: Int = 0
        var lowest = 2500
        var a: String
        var b: Substring
        for _ in 0...z.count-1{
            for y in z{
                a = "\(y.d.description)"
                b = a[a.firstIndex(of: " ")!...a.lastIndex(of: ":")!]
                b.remove(at: b.firstIndex(of: " ")!)
                b.remove(at: b.firstIndex(of: ":")!)
                b.remove(at: b.firstIndex(of: ":")!)
                if Int("\(b)")! < lowest{
                    lowest = Int("\(b)")!
                    next = y
                    index = z.firstIndex(of: y)!
                }
            }
            lowest = 2500
            new.append(next)
            z.remove(at: index)
        }
        return new
    }
    func getTime(s: String) -> String{
        let r: String
        var time = s[s.firstIndex(of: ":")!...s.lastIndex(of: ":")!]
        time.remove(at: time.lastIndex(of: ":")!)
        var hour = s[s.firstIndex(of: " ")!...s.firstIndex(of: ":")!]
        hour.remove(at: hour.firstIndex(of: " ")!)
        hour.remove(at: hour.firstIndex(of: ":")!)
        var m = Int(hour)!
        if m >= 16{
            m = m-16
            if m == 0{
                r = "12:00 PM"
            }
            else if m >= 10{
                r = "\(m)\(time) PM"
            }
            else{
                r = " \(m)\(time) PM"
            }
        }
        else{
            m = m-4
            if m == 0{
                r = "12:00 AM"
            }
            else if m >= 10{
                r = "\(m)\(time) AM"
            }
            else{
                r = " \(m)\(time) AM"
            }
        }
        return r
    }
}
