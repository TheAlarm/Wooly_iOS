//
//  Scheduler.swift
//  Wooly
//
//  Created by 이예슬 on 2021/06/22.
//

import Foundation
import UserNotifications

class Scheduler{
    
    static let shared = Scheduler()
    
    let center = UNUserNotificationCenter.current()
    
    func requestAuth(){
        let options: UNAuthorizationOptions = [.alert, .sound]
        center.requestAuthorization(options: options) {
            (granted, error) in
            print("granted NotificationCenter: \(granted)")
        }
    }
    
    func setUserNotification(memo contentTitle: String, time contentBody: String, triggerDateComponents: DateComponents, triggerRepeats: Bool, alarmIdentifier requestIdentifier: String){
        
        let content = UNMutableNotificationContent()
        let sound = UNNotificationSound(named: UNNotificationSoundName("example.mp3"))
        content.title = contentTitle
        content.body = contentBody
        content.sound = sound
        
        //MARK: TEST
        let intervalTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 3.0, repeats: false)
        let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: triggerRepeats)
//        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: intervalTrigger)
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: calendarTrigger)
        
        center.add(request, withCompletionHandler: nil)
    }
    
    func removeUserNotifications(alarmIdentifier requestIdentifier: String){
        center.removePendingNotificationRequests(withIdentifiers: [requestIdentifier])
    }
}

