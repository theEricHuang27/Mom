//
//  ViewController.swift
//  Mom
//
//  Created by Aidan Barr Bono (student LM) on 1/3/19.
//  Copyright © 2019 Duck Inc. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    func Notification(){
      
       // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0, repeats: false)
       // let request = UNNotificationRequest(identifier: "Notification", content: content, trigger: trigger)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in})
    }


}

