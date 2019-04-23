//
//  BlackboardViewController.swift
//  Mom
//
//  Created by Aidan Barr Bono (student LM) on 3/26/19.
//  Copyright © 2019 Duck Inc. All rights reserved.
//

import UIKit
import WebKit
import Kanna

class BlackboardViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var webView: WKWebView!
    var json: Data!
    var blackboardStruct: blackboardResponse!
    var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func syncWithBlackBoard(_ sender: UIButton) {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        webView = WKWebView(frame: view.bounds, configuration: configuration)
        view.addSubview(webView)
        webView.navigationDelegate = self
        let request = URLRequest(url: URL(string: "https://lmsd.blackboard.com/webapps/login/?action=relogin")!)
        webView.load(request)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let dates = DateInterval.init(start: Date.init(timeIntervalSinceNow: -2419200), duration: 9590400)
        let start = dates.start.description.split(separator: " ")[0]
        let end = dates.end.description.split(separator: " ")[0]
        if(webView.url! == URL(string: "https://lmsd.blackboard.com/webapps/portal/execute/tabs/tabAction?tab_tab_group_id=_1_1")){
            for x in defaults.dictionaryRepresentation().keys{
                if x.description.last == "2"{
                    defaults.removeObject(forKey: x)
                }
            }
            // moves the webview off the screen for loading things
            webView.translatesAutoresizingMaskIntoConstraints = false
            webView.leftAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            webView.topAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
            let request = URLRequest(url: URL(string:"https://lmsd.blackboard.com/learn/api/public/v1/calendars/items?since=\(start)T00:00:00.000Z&until=\(end)T00:00:00.000Z&limit=1000")!)
            webView.load(request)
        }

        if(webView.url! == URL(string: "https://lmsd.blackboard.com/learn/api/public/v1/calendars/items?since=\(start)T00:00:00.000Z&until=\(end)T00:00:00.000Z&limit=1000")){
            webView.evaluateJavaScript("document.documentElement.outerHTML.toString()",
                                       completionHandler: { (html: Any?, error: Error?) in
                                        do{
                                            let doc = try Kanna.HTML(html: html as! String, encoding: String.Encoding.utf8)
                                            self.json = doc.body!.text!.data(using: .utf8)!
                                            self.blackboardStruct = try JSONDecoder().decode(blackboardResponse.self, from: self.json)
                                            for results in self.blackboardStruct.results {
                                                let subject = results.title!
                                                var information = ""
//                                                var information = "<br>\(results.calendarName)<br>"
                                                if let a = results.description{
                                                    information += a
                                                }
                                                let formatter = ISO8601DateFormatter()
                                                formatter.formatOptions.insert(ISO8601DateFormatter.Options.withFractionalSeconds)
                                                let date =                                                 formatter.date(from: results.start!)!
                                                let event = Event(d: date, subject: subject, information: information)
                                                let dateString = self.getDate(d: event.d)
                                                // checks if it exists
                                                if let loadedData = defaults.data(forKey: "\(dateString)*2"){
                                                    // checks if it can make an array of events with the data
                                                    if let loadedEvents = NSKeyedUnarchiver.unarchiveObject(with: loadedData) as? [Event]{
                                                        self.events = loadedEvents
                                                        self.events.append(event)
                                                        let eventData = NSKeyedArchiver.archivedData(withRootObject: self.events)
                                                        defaults.set(eventData, forKey: "\(dateString)*2")
                                                    }
                                                }
                                                else{
                                                    self.events = []
                                                    self.events.append(event)
                                                    let eventData = NSKeyedArchiver.archivedData(withRootObject: self.events)
                                                    defaults.set(eventData, forKey: "\(dateString)*2")
                                                }
                                            }
                                        } catch let error as NSError {
                                            print(error)
                                        }
            })
        }
        
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
}
