//
//  GradesViewController.swift
//  Mom
//
//  Created by Aidan Barr Bono (student LM) on 4/28/19.
//  Copyright © 2019 Duck Inc. All rights reserved.
//

import UIKit

class GradesViewController: UIViewController, ThemedViewController {
    
    var backView: UIView { return self.view }
    var navBar: UINavigationBar { return self.navigationController!.navigationBar }
    var labels: [UILabel]? { return nil }
    var buttons: [UIButton]? { return nil }
    var textFields: [UITextField]? { return nil }
    func theme(isDarkTheme: Bool) {
        defaultTheme(isDarkTheme: isDarkTheme)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navBar.topItem?.title = "Grades"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        theme(isDarkTheme: SettingsViewController.isDarkTheme)
    }

}
