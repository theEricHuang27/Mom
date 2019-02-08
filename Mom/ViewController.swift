//
//  ViewController.swift
//  Mom
//
//  Created by Aidan Barr Bono (student LM) on 1/3/19.
//  Copyright © 2019 Duck Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func Calendar(_ sender: UIButton) {
        performSegue(withIdentifier: "HomeToCalendar", sender: self)
    }
}

