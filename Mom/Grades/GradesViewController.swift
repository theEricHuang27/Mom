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
    
    var backView: UIView { return self.view }
    var navBar: UINavigationBar { return self.navigationController!.navigationBar }
    var labels: [UILabel]? { return [gpaLabel, gpaScoreLabel] }
    var buttons: [UIButton]? { return nil }
    var textFields: [UITextField]? { return nil }
    
    var tableCellBackgroundColor: UIColor = UIColor.white
    
    func theme(isDarkTheme: Bool) {
        defaultTheme(isDarkTheme: isDarkTheme)
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

        // Do any additional setup after loading the view.
        navBar.topItem?.title = "Grades"
        
        gpaScoreLabel.text = String(format: "%.2f", GPAAVG)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        theme(isDarkTheme: SettingsViewController.isDarkTheme)
        gpaScoreLabel.text = String(format: "%.2f", GPAAVG)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return grades.count
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 1
        cell.backgroundColor = UIColor.myPurple
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = grades[indexPath.row]
        cell.layer.cornerRadius = 5
        cell.separatorInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        cell.layoutSubviews()
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let newView =  UIView()
        newView.backgroundColor = tableCellBackgroundColor
        return newView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // make a view controller that could view like the description of an event
        // we are pressed on time so idc
//        performSegue(withIdentifier: "toDescription", sender: self)
    }

}
