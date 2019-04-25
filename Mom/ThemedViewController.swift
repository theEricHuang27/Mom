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
    var tabBar: UITabBar { get }
    var navBar: UINavigationBar { get }
    var labels: [UILabel] { get }
    func theme(isDarkTheme: Bool) -> Void
}

extension ThemedViewController {
    func theme(isDarkTheme: Bool) -> Void {
        var labelTextColor: UIColor
        var backViewBackgroundColor: UIColor
        var navBarColor: UIColor
        var tabBarColor: UIColor
//        let tabBarApp = UITabBar.appearance()
//        var tabBarColor: UIColor
//        let navBarApp = UINavigationBar.appearance()
//        var navBarColor: UIColor
        
        if isDarkTheme {
            UserDefaults.standard.set(true, forKey: "DarkTheme")
//            tabBarColor = UIColor.white
//            navBarColor = UIColor.white
            labelTextColor = UIColor.white
            backViewBackgroundColor = UIColor.myDeepGrey
            navBarColor = UIColor.myDeepGrey
            tabBarColor = UIColor.myDeepGrey
        } else {
            UserDefaults.standard.set(false, forKey: "DarkTheme")
//            tabBarColor = UIColor.myDeepGrey
//            navBarColor = UIColor.myDeepGrey
            labelTextColor = UIColor.black
            backViewBackgroundColor = UIColor.white
            navBarColor = UIColor.white
            tabBarColor = UIColor.white
        }
        
        backView.backgroundColor = backViewBackgroundColor
        tabBar.barTintColor = tabBarColor
        navBar.barTintColor = navBarColor
//        navBarApp.barTintColor = navBarColor
//        tabBarApp.barTintColor = tabBarColor
        
        for label in labels {
            label.textColor = labelTextColor
        }
        
    }
}
