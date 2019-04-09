//
//  DescriptionViewController.swift
//  Mom
//
//  Created by Connor Stange (student LM) on 4/9/19.
//  Copyright © 2019 Duck Inc. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {

    @IBOutlet var Subject: UILabel!
    @IBOutlet var Day: UILabel!
    @IBOutlet var Description: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        Subject.text = subj
        Day.text = "\(dateString) @ \(time)"
        Description.text = desc
    }
}
