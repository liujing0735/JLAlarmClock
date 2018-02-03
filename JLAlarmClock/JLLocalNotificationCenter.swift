//
//  JLLocalPushCenter.swift
//  JLAlarmClock
//
//  Created by JasonLiu on 2017/8/3.
//  Copyright © 2017年 JasonLiu. All rights reserved.
//

import UIKit
import UserNotifications

class JLLocalPushCenter: NSObject,UNUserNotificationCenterDelegate {
    
    /// 注册本地通知 iOS 8.0 及以上
    func registerLocalNotification() -> Void {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.alert,.badge,.sound], completionHandler: { (granted: Bool, error: Error) in
                if granted {
                    center.getNotificationSettings(completionHandler: { (settings: UNNotificationSettings) in
                        
                    })
                }
                } as! (Bool, Error?) -> Void)
        }else if #available(iOS 8.0, *) {
            let settings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
    
    /// 添加本地通知
    ///
    /// - Parameters:
    ///   - fireDate: <#fireDate description#>
    ///   - key: <#key description#>
    ///   - alertTitle: <#alertTitle description#>
    ///   - alertBody: <#alertBody description#>
    ///   - alertAction: <#alertAction description#>
    ///   - alertLaunchImage: <#alertLaunchImage description#>
    ///   - soundName: <#soundName description#>
    ///   - userInfo: <#userInfo description#>
    ///   - repeatInterval: <#repeatInterval description#>
    func addLocalNotification(fireDate: Date,
                           key: String,
                    alertTitle: String!,
                     alertBody: String!,
                   alertAction: String!,
              alertLaunchImage: String!,
                     soundName: String!,
                      userInfo: [AnyHashable : Any]!,
                repeatInterval: NSCalendar.Unit) -> Void {
        
        let localNoti = UILocalNotification()
        localNoti.fireDate = fireDate
        localNoti.timeZone = NSTimeZone.default
        if alertTitle != nil {
            if #available(iOS 8.2, *) {
                localNoti.alertTitle = alertTitle
            } else {
                // Fallback on earlier versions
            }
        }
        if alertBody != nil {
            localNoti.alertBody = alertBody
        }
        if alertAction != nil {
            localNoti.alertAction = alertAction
        }
        if alertLaunchImage != nil {
            localNoti.alertLaunchImage = alertLaunchImage
        }
        if soundName != nil {
            localNoti.soundName = soundName
        }else {
            localNoti.soundName = UILocalNotificationDefaultSoundName
        }
        var info: Dictionary<AnyHashable,Any> = ["key":key]
        if userInfo != nil {
            for e in userInfo {
                info[e.key] = userInfo[e.key]
            }
        }
        localNoti.userInfo = info
        localNoti.repeatInterval = repeatInterval
        
        UIApplication.shared.scheduleLocalNotification(localNoti)
    }
    
    /// 移除本地通知
    ///
    /// - Parameter key: <#key description#>
    /// - Returns: <#return value description#>
    func removeLocalNotification(key: String) -> Bool {
        if let locals = UIApplication.shared.scheduledLocalNotifications {
            for localNoti in locals {
                if let dict = localNoti.userInfo {
                    if dict.keys.contains("key") && dict["key"] is String && (dict["key"] as! String) == key {
                        UIApplication.shared.cancelLocalNotification(localNoti)
                        return true
                    }
                }
            }
        }
        return false
    }
}
