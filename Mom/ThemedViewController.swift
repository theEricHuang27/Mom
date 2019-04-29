//
//  ThemedViewController.swift
//  Mom
//
//  Created by Aidan Barr Bono (student LM) on 4/24/19.
//  Copyright © 2019 Duck Inc. All rights reserved.
//

import Foundation
import UIKit

protocol ThemedViewController {
    
    // common storyboard element types are included in the protocol
    // as well as the view and nav bar because they are in every VC
    var backView: UIView { get }
    var navBar: UINavigationBar { get }
    var labels: [UILabel]? { get }
    var buttons: [UIButton]? { get }
    var textFields: [UITextField]? { get }
    
    // this function is where storyboard elements' colors are changed
    func theme(isDarkTheme: Bool) -> Void
}

// this extension provides a "defaul implementation" of the theme function
extension ThemedViewController {
    func defaultTheme(isDarkTheme: Bool) -> Void {
        
        // color variables initialized
        var backViewBackgroundColor: UIColor
        var navBarColor: UIColor
        var labelTextColor: UIColor
        var buttonTextColor: UIColor
        var textFieldTextColor: UIColor
        var textFieldBackgroundColor: UIColor
        
        // color variables set according to theme
        // theme variable is alo changed
        if isDarkTheme {
            SettingsViewController.isDarkTheme = true
            labelTextColor = UIColor.white
            backViewBackgroundColor = UIColor.myDeepGrey
            navBarColor = UIColor.myPurple
            buttonTextColor = UIColor.myYellow
            textFieldTextColor = UIColor.white
            textFieldBackgroundColor = UIColor.clear
        } else {
            SettingsViewController.isDarkTheme = false
            labelTextColor = UIColor.black
            backViewBackgroundColor = UIColor.white
            navBarColor = UIColor.myPurple
            buttonTextColor = UIColor.myMagenta
            textFieldTextColor = UIColor.black
            textFieldBackgroundColor = UIColor.clear
        }
        
        // color variables used to set colors of storyboard elements
        backView.backgroundColor = backViewBackgroundColor
        navBar.barTintColor = navBarColor
        
        if let labels = labels {
            for label in labels {
                label.textColor = labelTextColor
            }
        }
        if let buttons = buttons {
            for button in buttons {
                button.setTitleColor(buttonTextColor, for: .normal)
            }
        }
        
        if let textFields = textFields {
            for textField in textFields {
                textField.textColor = textFieldTextColor
                textField.backgroundColor = textFieldBackgroundColor
            }
        }
        
    }
}

/*
 This protocol should be implemented to every view controller that could have changes based on the theme
 The variables at the top should be filled with outlet connections
 Each view controller should override the viewWillAppear(animated:) function like so
 
 override func viewWillAppear(_ animated: Bool) {
 super.viewWillAppear(animated)
 theme(isDarkTheme: UserDefaults.standard.bool(forKey: "DarkTheme"))
 }
 
 The theme(isDarkTheme:) method should be implemented like so
 
 func theme(isDarkTheme: Bool) {
 self.defaultTheme(isDarkTheme: isDarkTheme)
 // other VC specific theme changes
 }
 */
