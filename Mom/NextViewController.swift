//
//  NextViewController.swift
//  Mom
//
//  Created by Connor Stange (student LM) on 1/29/19.
//  Copyright © 2019 Duck Inc. All rights reserved.
// display

import UIKit

class NextViewController: UIViewController {
    
    var events: [Event] = []
    @IBOutlet weak var DateLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        DateLabel.text = dateString
        if let e = defaults.array(forKey: dateString){
            events = e as! [Event]
        }
//        events = UserDefaults.standard.array(forKey: dateString)
    }
    @IBAction func NewEvent(_ sender: Event) {
//        events.append(getEvent())
    }
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
}
