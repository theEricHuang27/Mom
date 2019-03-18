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
//    static var reminderTime : [Int]? = [0, 0, 0]
    static var reminderDateComponents : DateComponents? = DateComponents(year: 0, month: 0, day: 0, hour: 0, minute: 0, second: 5)
    
    
    static func generateNotificationFrom(_ event : Event) {
        let content = UNMutableNotificationContent()
        content.title = "On Point"
        content.subtitle = event.subject
        content.body = event.information
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = "ALERT"
        
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        
        if let reminderComponents = reminderDateComponents {
                
                dateComponents = calendar.dateComponents([.second, .minute, .hour, .day, .month, .year], from: event.date)
                dateComponents.day = dateComponents.day! - (reminderComponents.day ?? 0)
                dateComponents.hour = dateComponents.hour! - (reminderComponents.hour ?? 0)
                dateComponents.minute = dateComponents.minute! - (reminderComponents.minute ?? 0)
                dateComponents.second = dateComponents.second! - (reminderComponents.second ?? 0)
                
        }
        
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
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
