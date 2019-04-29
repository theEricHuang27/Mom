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
    
    // make these { set get } properties that link directly into the userDefaults
//    static var snoozeTime : TimeInterval = 5
    static var snoozeTime: Int {
        get {
            return UserDefaults.standard.integer(forKey: "snoozeTime")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "snoozeTime")
        }
    }
    static var reminderDateComponents: DateComponents? {
        get {
            // MUST FIND WAY TO STORE NIL
            // try using object(forKey:) again
            if let arr =  UserDefaults.standard.array(forKey: "reminderTimeBefore") as! [Int]? {
                return DateComponents(hour: arr[0], minute: arr[1])
            } else {
                return nil
            }
        }
        set {
            if let comps = newValue {
                let arr = [comps.hour, comps.minute]
                UserDefaults.standard.set(arr, forKey: "reminderTimeBefore")
            } else {
                UserDefaults.standard.set(nil, forKey: "reminderTimeBefore")
            }
            
        }
    }
    
    
    static func generateNotificationFrom(_ event : Event) {
        
        // if they don't have notifications on don't make a notification
        guard let reminderComponents = reminderDateComponents else { return }
        
        // create content for the notification
        let content = UNMutableNotificationContent()
        content.title = "On Point"
        content.subtitle = event.subject
        content.body = event.information
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = NotificationTypes.alert
        
        // set up
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        
        // create trigger for the time before the notification
        dateComponents = calendar.dateComponents([.second, .minute, .hour, .day, .month, .year], from: event.d)
        print(reminderComponents)
        let triggerComponents = generateComponentsFrom(referenceTime: dateComponents, before: reminderComponents)
        
        // finish creating and add notification request
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)
        let request = UNNotificationRequest(identifier: NotificationTypes.alert, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    static func generateSnoozeNotificationFrom(_ request : UNNotificationRequest) {
        
        // create a time interval trigger for after the event and add the reqeust
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(Notifications.snoozeTime), repeats: false)
        let request = UNNotificationRequest(identifier: NotificationTypes.snooze, content: request.content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    static func createOptions(){
        // create view and snooze actions and add them to categores
        // called from AppDelegate didFinishLaunchingWithOptions:
        let view = UNNotificationAction(identifier: "VIEW", title: "View", options: .foreground)
        let snooze = UNNotificationAction(identifier: "SNOOZE", title: "Snooze", options: UNNotificationActionOptions(rawValue: 0))
        let alertCategory = UNNotificationCategory(identifier: NotificationTypes.alert, actions: [view, snooze], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)
        UNUserNotificationCenter.current().setNotificationCategories([alertCategory])
        

    }
    
    // called to recreate all the notifications when the settings swap
    // called from SettingsViewController
    static func redoNotifications() {
        
        // if they don't want any notifications
        guard let reminder = reminderDateComponents else {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [NotificationTypes.alert])
            return
        }
        
        // holder list
        var requestsToBeChanged : [UNNotificationRequest] = []
        
        // fill with requests that should be redone
        UNUserNotificationCenter.current().getPendingNotificationRequests() { requests in
            for request in requests {
                if request.identifier == NotificationTypes.alert {
                    requestsToBeChanged.append(request)
                }
            }
        }
        
        // remove all the requests and remake them
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [NotificationTypes.alert])
        for request in requestsToBeChanged {
            let oldTrigger = request.trigger as! UNCalendarNotificationTrigger
            let dateComponents = generateComponentsFrom(referenceTime: oldTrigger.dateComponents, before: reminder)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let newRequest = UNNotificationRequest(identifier: request.identifier, content: request.content, trigger: trigger)
            UNUserNotificationCenter.current().add(newRequest, withCompletionHandler: nil)
        }
    }
    
    // utility function to find the the difference of two DateComponents
    static func generateComponentsFrom(referenceTime: DateComponents, before: DateComponents) -> DateComponents {
        var newComponents = DateComponents()
        newComponents.day = referenceTime.day! - (before.day ?? 0)
        newComponents.hour = referenceTime.hour! - (before.hour ?? 0)
        newComponents.minute = referenceTime.minute! - (before.minute ?? 0)
        newComponents.second = referenceTime.second! - (before.second ?? 0)
        return newComponents
    }
}

struct NotificationTypes {
    static var alert = "ALERT"
    static var snooze = "SNOOZE"
}