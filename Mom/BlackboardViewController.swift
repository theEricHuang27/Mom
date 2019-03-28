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

//var defaults = UserDefaults.standard

class BlackboardViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var webView: WKWebView!
    var json: Data!
    var calenderStruct: blackboardResponse!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        print("loaded")
        print(webView.url!)
        let dates = DateInterval.init(start: Date.init(timeIntervalSinceNow: -2419200), duration: 9590400)
        let start = dates.start.description.split(separator: " ")[0]
        let end = dates.end.description.split(separator: " ")[0]
        
        if(webView.url! == URL(string: "https://lmsd.blackboard.com/webapps/portal/execute/tabs/tabAction?tab_tab_group_id=_1_1")){
            
            // moves the webview off the screen for loading things
            webView.translatesAutoresizingMaskIntoConstraints = false
            webView.leftAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            webView.topAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
            let request = URLRequest(url: URL(string:"https://lmsd.blackboard.com/learn/api/public/v1/calendars/items?since=\(start)T00:00:00.000Z&until\(end)T00:00:00.000Z")!)
            webView.load(request)
        }
        
        if(webView.url! == URL(string: "https://lmsd.blackboard.com/learn/api/public/v1/calendars/items?since=\(start)T00:00:00.000Z&until\(end)T00:00:00.000Z")){
            webView.evaluateJavaScript("document.documentElement.outerHTML.toString()",
                                       completionHandler: { (html: Any?, error: Error?) in
                                        do{
                                            let doc = try Kanna.HTML(html: html as! String, encoding: String.Encoding.utf8)
                                            print(doc.body!.text!)
                                            self.json = doc.body!.text!.data(using: .utf8)!
                                            self.calenderStruct = try JSONDecoder().decode(blackboardResponse.self, from: self.json)
                                        } catch let error as NSError {
                                            print(error)
                                        }
            })
//            webView.removeFromSuperview()
        }
        
    }

}
