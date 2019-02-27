//
//  NextViewController.swift
//  Mom
//
//  Created by Connor Stange (student LM) on 1/29/19.
//  Copyright © 2019 Duck Inc. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {

    var events: [Event] = []
    @IBOutlet weak var DateLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        DateLabel.text = dateString
    }
    @IBAction func NewEvent(_ sender: Event) {

    }
}
