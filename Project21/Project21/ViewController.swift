//
//  ViewController.swift
//  Project21
//
//  Created by Yurii Sameliuk on 04/06/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: UIBarButtonItem.Style.plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: UIBarButtonItem.Style.plain, target: self, action: #selector(scheduleLocal))
        
    }

    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Hello!")
            } else {
                print("No")
            }
        }
    }
    
    @objc func scheduleLocal() {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        // 4to pokazuwat
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        // kogda pokazuwat
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // 5 sec
       // kombinacija triggera i contenta
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: UNNotificationActionOptions.foreground)
        let showLater = UNNotificationAction(identifier: "showLater", title: "show a next day", options: UNNotificationActionOptions.foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, showLater], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data recived: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                print("default identifier")
            case "show":
                print("show more information...")
            case "showLater":
                let center = UNUserNotificationCenter.current()
                center.removeAllPendingNotificationRequests()
                // 4to pokazuwat
                let content = UNMutableNotificationContent()
                content.title = "Wake up call"
                content.body = "The early bird catches the worm, but the second mouse gets the cheese."
                content.categoryIdentifier = "alarm"
                content.userInfo = ["customData": "fizzbuzz"]
                content.sound = .default
                var dateComponents = DateComponents()
               // dateComponents.hour = 10
                dateComponents.second = 20
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                center.add(request, withCompletionHandler: nil)
            default:
                break
            }
        }
        completionHandler()
    }
}

