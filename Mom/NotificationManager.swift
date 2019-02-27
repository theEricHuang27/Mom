//
//  NotificationManager.swift
//  Mom
//
//  Created by Aidan Barr Bono (student LM) on 2/21/19.
//  Copyright © 2019 Duck Inc. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationManager : NSObject, UNUserNotificationCenterDelegate {
    
//    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
//
//    })
//
//    NotificationManager.createOptions()
//
//    GetStartDateDayPosition()
//    NotificationManager.sendNotification(Event(date: Date(), subject: "help", information: "me"))
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //displaying the ios local notification when app is in foreground
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        <#code#>
    }
    
    static func sendNotification(_ e : Event) {
        let content = UNMutableNotificationContent()
        content.title = "On Point"
        content.subtitle = e.subject
        content.sound = UNNotificationSound.default
        content.badge = 1       // Badge of 1 refers to the app's icon
        content.categoryIdentifier = "ALERT"
        
        content.body = "You have a test tomorrow! Get to studying!"
        var dateThing = DateComponents()
        dateThing.hour = 12
        dateThing.minute = 26
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10 , repeats: false)
        //        let trigger2 = UNCalendarNotificationTrigger(dateMatching: dateThing, repeats: false)
        let request = UNNotificationRequest(identifier: "Notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    static func createOptions(){
        let view = UNNotificationAction(identifier: "VIEW", title: "View", options: UNNotificationActionOptions(rawValue: 0))
        let snooze = UNNotificationAction(identifier: "SNOOZE", title: "Snooze", options: UNNotificationActionOptions(rawValue: 0))
        let alertCategory = UNNotificationCategory(identifier: "ALERT", actions: [view, snooze], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)
        UNUserNotificationCenter.current().setNotificationCategories([alertCategory])
    }
}
