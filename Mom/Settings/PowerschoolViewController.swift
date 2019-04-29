//
//  PowerschoolViewController.swift
//  Mom
//
//  Created by Aidan Barr Bono (student LM) on 4/28/19.
//  Copyright © 2019 Duck Inc. All rights reserved.
//

import UIKit
import Kanna
import WebKit

var GPAAVG = 0.0
var grades: [String] = []

class PowerschoolViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, ThemedViewController {
    
    var backView: UIView { return self.view }
    var navBar: UINavigationBar { return self.navigationController!.navigationBar }
    var labels: [UILabel]? { return nil }
    var buttons: [UIButton]? { return nil }
    var textFields: [UITextField]? { return nil }
    @IBOutlet var webView: WKWebView!
    var links: [String] = []
    var GPA:[String]=[]
    var timer : Timer?
    var click = 0
    var finished = false
    var timer2 : Timer?
    var timer3 : Timer?
    func theme(isDarkTheme: Bool) {
        defaultTheme(isDarkTheme: isDarkTheme)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let myRequest = URLRequest(url: URL(string: "https://powerschool.lmsd.org/public/")!)
        webView.load(myRequest)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        theme(isDarkTheme: SettingsViewController.isDarkTheme)
    }
    @objc func fireTimer2() {
        if click>self.links.count{
            timer2?.invalidate()
        }
        self.webView.load( URLRequest(url: URL(string: "https://powerschool.lmsd.org/guardian/"+self.links[0])!))
        self.click=self.click+1
        self.webView.evaluateJavaScript("document.documentElement.outerHTML.toString()", completionHandler: { (html1: Any?, error: Error?) in
            do {
                self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.fireTimer), userInfo: nil, repeats: false)
            }
            catch _ {
            }
        })
    }
    
    @objc func fireTimer() {
        self.webView.evaluateJavaScript("document.documentElement.outerHTML.toString()", completionHandler: { (html1: Any?, error: Error?) in
            do {
                var grade = ""
                var ghold:String  = ""
                var count = 2
                var count2 = 0
                for char in [Character]((try Kanna.HTML(html: html1 as! String, encoding: String.Encoding.utf8, option: kDefaultHtmlParseOption).content?.characters)!){
                    grade.append(char)
                }
                grade = String(grade[grade.index(grade.firstIndex(of: "@")!, offsetBy: 31968)...])
                grade = grade.removeExtraSpaces()
                grade = grade.replacingOccurrences(of: " collected late missing exempt from final grade absent incomplete excluded from final grade ", with: " ")
                grade = grade.replacingOccurrences(of: "DISCLAIMER: This system is provided as a convenience. Grades and other information provided by this system are not official records and may or may not be accurate. Neither this institution nor PowerSchool Group LLC or its affiliates accepts any responsibility for information provided by this system and/or for any damages resulting from information provided by this system. For official grades and student records contact your school. Copyright © 2005-2018 PowerSchool Group LLC and/or its affiliate(s). All rights reserved.All trademarks are either owned or licensed by PowerSchool Group LLC and/or its affiliates.", with: " ")
                grade = grade.replacingOccurrences(of: "Legend 1 - This final grade may include assignments that are not yet published, or may be the result of special weighting used by the teacher. Click to view additional information on special weighting. Icons - Has Description | - Has Comment | - Collected | - Late | - Missing | - Exempt from Final Grade | - Absent | - Incomplete | - Excluded notifier.displayGuardian();", with: " ")
                grade = grade.replacingOccurrences(of: "td.stdCol { padding: 2px; width: 40px; min-width: 40px; } td.codeCol { padding: 2px; width: 20px; min-width: 20px; } td.stdNA { opacity: .5; border: none !important; } .noStyle td { background-color: #fff !important; } table.zebra tbody tr.sub>td { border-top: none; border-bottom: none; }", with: " ")
                grade = "\(grade)"
                print(grade)
                for char in 0...grade.count-10{
                    if "\(grade[grade.index(grade.firstIndex(of: " ")!, offsetBy: char)])" == "0" && "\(grade[grade.index(grade.firstIndex(of: " ")!, offsetBy: char+1)])" == "/" && "\(grade[grade.index(grade.firstIndex(of: " ")!, offsetBy: char-1)])" == " " {
                        while !("\(grade[grade.index(grade.firstIndex(of: " ")!, offsetBy: char-count)])" == "/" && "\(grade[grade.index(grade.firstIndex(of: " ")!, offsetBy: char-count+3)])" == "/"){
                            ghold = "\(grade[grade.index(grade.firstIndex(of: " ")!, offsetBy: char-count-2)...grade.index(grade.firstIndex(of: " ")!, offsetBy: char-count-2)])"
                            count = count+1
                        }
                        while "\(grade[grade.index(grade.firstIndex(of: " ")!, offsetBy: char+count2)])" != " " {
                            count2 = count2+1
                        }
                        ghold = "\(grade[grade.index(grade.firstIndex(of: " ")!, offsetBy: char-count-2)...grade.index(grade.firstIndex(of: " ")!, offsetBy: char-2)]) \(grade[grade.index(grade.firstIndex(of: " ")!, offsetBy: char)...grade.index(grade.firstIndex(of: " ")!, offsetBy: char+count2)])"
                        print(ghold)
                        grades.append(ghold)
                        count2=0
                        count=93
                    }
                    ghold=""
                }
            }
            catch _ {
            }
        })
        self.finished=true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if(webView.url! == URL(string: "https://powerschool.lmsd.org/guardian/home.html")){
            let request = URLRequest(url: URL(string: "https://powerschool.lmsd.org/guardian/home.html")!)
            webView.load(request)
            webView.evaluateJavaScript("document.documentElement.outerHTML.toString()", completionHandler: { (html: Any?, error: Error?) in
                do {
                 
                    let htmlDoc = try Kanna.HTML(html: html as! String, encoding: String.Encoding.utf8, option: kDefaultHtmlParseOption)
                    var html = htmlDoc.innerHTML
                    var holder = ""
                    var GPAHolder = ""
                    var count = 0
                    var count2 = 0
                    var miss = 0
                    var htmlList = [Character](html!.characters)
                    for char in 0..<html!.count{
                        if htmlList[char]=="\"" && htmlList[char+1]=="s" && htmlList[char+2]=="c" && htmlList[char+3]=="o" && htmlList[char+4]=="r" && htmlList[char+5]=="e" && htmlList[char+6]=="s" && htmlList[char+7]=="." && htmlList[char+8]=="h" && htmlList[char+9]=="t" && htmlList[char+10]=="m" && htmlList[char+11]=="l" && htmlList[char+12]=="?" && htmlList[char+13]=="f" && htmlList[char+14]=="r" && htmlList[char+15]=="n" && htmlList[char+16]=="="{
                            for i in 1...16{
                                holder.append(htmlList[char+i])
                            }
                            count = 17
                            while htmlList[char+count] != "\""{
                                holder.append(htmlList[char+count])
                                count=count+1
                            }
                            self.links.append(holder)
                            holder=""
                            count=0
                        }
                    }
                    var c = self.links.count
                    print(c)
                    for i in 1...c{
                        if "\(self.links[c-i][self.links[c-i].index(self.links[c-i].firstIndex(of: "s")!,offsetBy: self.links[c-i].count-2)])" != "Y"{
                            self.links.remove(at: c-i)
                        }
                    }
                    
                    for char in 0..<html!.count{
                        if htmlList[char]=="Y" && htmlList[char+1]=="1"{
                            count2 = 17
                            while htmlList[char+count2] != "<"{
                                GPAHolder.append(htmlList[char+count2])
                                count2=count2+1
                            }
                            self.GPA.append(GPAHolder)
                            GPAHolder=""
                        }
                    }
                    for grade in self.GPA{
                        if grade == "A+"{
                            GPAAVG=GPAAVG+4.3
                        }
                        else if grade == "A"{
                            GPAAVG=GPAAVG+4
                        }
                        else if grade == "A-"{
                            GPAAVG=GPAAVG+3.7
                        }
                        else if grade == "B+"{
                            GPAAVG=GPAAVG+3.3
                        }
                        else if grade == "B"{
                            GPAAVG=GPAAVG+3
                        }
                        else if grade == "B-"{
                            GPAAVG=GPAAVG+2.7
                        }
                        else if grade == "C+"{
                            GPAAVG=GPAAVG+2.3
                        }
                        else if grade == "C"{
                            GPAAVG=GPAAVG+2.0
                        }
                        else if grade == "C-"{
                            GPAAVG=GPAAVG+1.7
                        }
                        else if grade == "D+"{
                            GPAAVG=GPAAVG+1.3
                        }
                        else if grade == "D"{
                            GPAAVG=GPAAVG+1.0
                        }
                        else if grade == "D-"{
                            GPAAVG=GPAAVG+0.7
                        }
                        else {
                            miss=miss+1
                        }
                    }
                    GPAAVG=GPAAVG/Double(self.GPA.count-miss)
                    print(GPAAVG)
                    
                    print(self.links)
                    for z in 0...self.links.count-2{
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4*(z)), execute: {
                            self.webView.load( URLRequest(url: URL(string: "https://powerschool.lmsd.org/guardian/"+self.links[z])!))
                            self.webView.evaluateJavaScript("document.documentElement.outerHTML.toString()", completionHandler: { (html1: Any?, error: Error?) in
                                do {
                                    self.timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.fireTimer), userInfo: nil, repeats: false)
                                }
                                catch _ {
                                }
                            })
                        })
                        //                        Thread.sleep(until: Date(timeIntervalSinceNow: 5))
                    }
                }
                catch _ {
                }
            })
        }
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
        webView.navigationDelegate = self
    }
}

extension String {
    func removeExtraSpaces() -> String {
        return self.replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression, range: nil)
    }
}


