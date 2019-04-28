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
    var backView: UIView { get }
    var navBar: UINavigationBar { get }
    var labels: [UILabel]? { get }
    var buttons: [UIButton]? { get }
    var textFields: [UITextField]? { get }
    func theme(isDarkTheme: Bool) -> Void
}

extension ThemedViewController {
    func defaultTheme(isDarkTheme: Bool) -> Void {
        var backViewBackgroundColor: UIColor
        var navBarColor: UIColor
//        let tabBarApp = UITabBar.appearance()
//        var tabBarColor: UIColor
//        let navBarApp = UINavigationBar.appearance()
//        var navBarColor: UIColor
        var labelTextColor: UIColor
        var buttonTextColor: UIColor
        var textFieldTextColor: UIColor
        var textFieldBackgroundColor: UIColor
        var buttonBackgroundColor: UIColor
        
        if isDarkTheme {
            UserDefaults.standard.set(true, forKey: "DarkTheme")
//            tabBarColor = UIColor.white
            labelTextColor = UIColor.white
            backViewBackgroundColor = UIColor.myDeepGrey
            navBarColor = UIColor.myPurple
            buttonTextColor = UIColor.myYellow
            buttonBackgroundColor = UIColor.myBlue
            textFieldTextColor = UIColor.white
            textFieldBackgroundColor = UIColor.clear
        } else {
            UserDefaults.standard.set(false, forKey: "DarkTheme")
//            tabBarColor = UIColor.myDeepGrey
            labelTextColor = UIColor.black
            backViewBackgroundColor = UIColor.white
            navBarColor = UIColor.myPurple
            buttonTextColor = UIColor.myMagenta
            buttonBackgroundColor = UIColor.white
            textFieldTextColor = UIColor.black
            textFieldBackgroundColor = UIColor.clear
        }
        
        backView.backgroundColor = backViewBackgroundColor
        navBar.barTintColor = navBarColor
//        navBarApp.barTintColor = navBarColor
        if let labels = labels {
            for label in labels {
                label.textColor = labelTextColor
            }
        }
        if let buttons = buttons {
            for button in buttons {
                button.setTitleColor(buttonTextColor, for: .normal)
    //            button.backgroundColor = buttonBackgroundColor
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
