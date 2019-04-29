//
//  GradesViewController.swift
//  Mom
//
//  Created by Aidan Barr Bono (student LM) on 4/28/19.
//  Copyright © 2019 Duck Inc. All rights reserved.
//

import UIKit

class GradesViewController: UIViewController, ThemedViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var gpaLabel: UILabel!
    @IBOutlet weak var gpaScoreLabel: UILabel!
    
    // implement ThemedViewController Protocol
    var backView: UIView { return self.view }
    var navBar: UINavigationBar { return self.navigationController!.navigationBar }
    var labels: [UILabel]? { return [gpaLabel, gpaScoreLabel] }
    var buttons: [UIButton]? { return nil }
    var textFields: [UITextField]? { return nil }
    
    // used to k eep background color consistent
    var tableCellBackgroundColor: UIColor = UIColor.white
    
    func theme(isDarkTheme: Bool) {
        defaultTheme(isDarkTheme: isDarkTheme)
        
        // VC specific theme
        if isDarkTheme {
            tableView.backgroundColor = UIColor.myDeepGrey
            tableCellBackgroundColor = UIColor.myDeepGrey
        } else {
            tableView.backgroundColor = UIColor.white
            tableCellBackgroundColor = UIColor.white
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set title of VC
        navBar.topItem?.title = "Grades"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        theme(isDarkTheme: SettingsViewController.isDarkTheme)
        if let gpa = defaults.double(forKey: "GPA") as Double? {
            gpaScoreLabel.text = String(format: "%.2f", gpa)
        }
        else{
            gpaScoreLabel.text = "0.00"
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // spacing between cells
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    // set to however many grades need to be displayed
    func numberOfSections(in tableView: UITableView) -> Int {
        if let glist = defaults.array(forKey: "grades") as! [String]? {
            return glist.count
        }
        else{
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // color updates should be done here
        cell.alpha = 1
        cell.backgroundColor = UIColor.myPurple
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // set cell content and aesthetics
        let cell = UITableViewCell()
        if let glist = defaults.array(forKey: "grades") as! [String]? {
            cell.textLabel?.text = glist[indexPath.section]
        }
        else{
            cell.textLabel?.text = ""
        }
        
        cell.layer.cornerRadius = 5
        cell.separatorInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        cell.layoutSubviews()
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // set color to get clean look
        let newView =  UIView()
        newView.backgroundColor = UIColor.clear
        return newView
    }
}
