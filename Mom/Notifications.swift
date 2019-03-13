//
//  Notifications.swift
//  Mom
//
//  Created by Aidan Barr Bono (student LM) on 2/28/19.
//  Copyright © 2019 Duck Inc. All rights reserved.
//

import Foundation
import UserNotifications

class Notifications : NSObject {
    
    static var snoozeTime = 5
    static var reminderTime = 5
    
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert, .sound])
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        // code when an ation is chosen
//        switch response.actionIdentifier {
//        case "SNOOZE": Notifications.generateSnoozeNotificationFrom(response.notification.request)
//        case "VIEW": break
//        default: break
//        }
//    }
    
    static func generateNotificationFrom(_ event : Event) {
        let content = UNMutableNotificationContent()
        content.title = "On Point"
        content.subtitle = event.subject
        content.body = event.information
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = "ALERT"
        
        
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.second, .minute, .hour, .day, .month, .year], from: event.date)
        dateComponents.second = dateComponents.second! + 15
        
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: "ALERT", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    static func generateSnoozeNotificationFrom(_ request : UNNotificationRequest) {
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(identifier: "ALERT", content: request.content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    static func createOptions(){
        let view = UNNotificationAction(identifier: "VIEW", title: "View", options: .foreground)
        let snooze = UNNotificationAction(identifier: "SNOOZE", title: "Snooze", options: UNNotificationActionOptions(rawValue: 0))
        let alertCategory = UNNotificationCategory(identifier: "ALERT", actions: [view, snooze], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)
        UNUserNotificationCenter.current().setNotificationCategories([alertCategory])
    }
}
