//
//  LocalNotificationHelperClass.swift
//  RekoApp
//
//  Created by Sandra Sundqvist on 2019-04-24.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotificationHelper: NSObject, UNUserNotificationCenterDelegate{
    
    
    private static var localNotificationHelperInstance: LocalNotificationHelper?
    private let center = UNUserNotificationCenter.current()
    private let notificationtitle = "New order!"
    private let notificationBody = ""
    private let notificationIdentifier = "OrderNotification"
    
    private override init() {
        
    }
    
    static func getInstance()->LocalNotificationHelper{
        if localNotificationHelperInstance == nil{
            localNotificationHelperInstance = LocalNotificationHelper()
        }
        return localNotificationHelperInstance!
    }
    
    func pushLocalNotification(message: String, ShouldRepeat: Bool) {
            let content = UNMutableNotificationContent()
            content.title = self.notificationtitle
            content.body = message
            content.sound = UNNotificationSound.defaultCritical
            content.badge = 1
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            //Sparar ner förfrågan om en notifikation enligt vad som ska trigga den
            let request = UNNotificationRequest(identifier: self.notificationIdentifier, content: content, trigger: trigger)
            
            self.center.delegate = self
            self.center.add(request, withCompletionHandler: nil)
            
        
    }
    
    func requestForPermission(onCompletion:@escaping(Bool)->Void){
        //Ber om lov av användaren att skicka notifikationer
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
            if didAllow{
                onCompletion(true)
            }else{
                onCompletion(false)
            }
        })
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge]) 
    }

    
}
