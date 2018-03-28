//
//  JLLocalNotificationManager.swift
//  JLAlarmClock
//
//  Created by JasonLiu on 2017/8/3.
//  Copyright © 2017年 JasonLiu. All rights reserved.
//

import UIKit
import UserNotifications

enum JLRepeatInterval {
    case None
    case Year
    case Month
    case Weekday
    case Day
    case Hour
    case Minute
    case Second
}

enum JLWeekday: Int {
    case Sunday = 1
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
}

class JLLocalNotificationManager: NSObject,UNUserNotificationCenterDelegate {
    
    static let shared: JLLocalNotificationManager = {
        let sharedInstance = JLLocalNotificationManager.init()
        return sharedInstance
    }()
    private override init() {
        super.init()
    }
    
    @available(iOS 10.0, *)
    private func repeatForIOS10(fireDate: Date, repeatInterval: JLRepeatInterval) -> UNNotificationTrigger {
        
        let calendar: Calendar = Calendar.current
        let fireComponents: DateComponents = calendar.dateComponents([.year,.month,.weekday,.weekdayOrdinal,.day,.hour,.minute,.second], from: fireDate)
        
        switch repeatInterval {
        case .None:
            
            var components = DateComponents()
            components.month = fireComponents.month
            components.day = fireComponents.day
            components.hour = fireComponents.hour
            components.minute = fireComponents.minute
            components.second = fireComponents.second
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false);
            return trigger
        case .Year:
            
            var components = DateComponents()
            components.month = fireComponents.month
            components.day = fireComponents.day
            components.hour = fireComponents.hour
            components.minute = fireComponents.minute
            components.second = fireComponents.second
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true);
            return trigger
        case .Month:
            
            var components = DateComponents()
            components.day = fireComponents.day
            components.hour = fireComponents.hour
            components.minute = fireComponents.minute
            components.second = fireComponents.second
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true);
            return trigger
        case .Weekday:
            
            var components = DateComponents()
            components.weekday = fireComponents.weekday
            components.hour = fireComponents.hour
            components.minute = fireComponents.minute
            components.second = fireComponents.second
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true);
            return trigger
        case .Day:
            
            var components = DateComponents()
            components.hour = fireComponents.hour
            components.minute = fireComponents.minute
            components.second = fireComponents.second
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true);
            return trigger
        case .Hour:
            
            var components = DateComponents()
            components.minute = fireComponents.minute
            components.second = fireComponents.second
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true);
            return trigger
        case .Minute:
            
            var components = DateComponents()
            components.second = fireComponents.second
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true);
            return trigger
        case .Second:
            
            let timeInterval = 60.0
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: true)
            return trigger
        }
    }
    
    private func repeatForIOS8(fireDate: Date, repeatInterval: JLRepeatInterval) -> NSCalendar.Unit {
        switch repeatInterval {
        case .None:
            return NSCalendar.Unit(rawValue: 0)
        case .Year:
            return .year
        case .Month:
            return .month
        case .Weekday:
            return .weekday
        case .Day:
            return .day
        case .Hour:
            return .hour
        case .Minute:
            return .minute
        case .Second:
            return .second
        }
    }
    
    /// 注册本地通知 iOS 8.0 及以上
    func registerLocalNotification() -> Void {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.alert,.badge,.sound], completionHandler: { (granted: Bool, error: Error!) in
                    if granted {
                        center.getNotificationSettings(completionHandler: { (settings: UNNotificationSettings) in
                            
                        })
                    }
                })
        }else if #available(iOS 8.0, *) {
            let settings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
    
    /// 添加本地通知
    ///
    /// - Parameters:
    ///   - fireDate: 启动时间
    ///   - identifier: 标识符
    ///   - alertTitle: 标题
    ///   - alertBody: 主体内容
    ///   - alertAction:
    ///   - alertLaunchImage: 预览图
    ///   - soundName: 提示音
    ///   - userInfo: 自定义参数
    ///   - repeatInterval: 循环周期
    func addLocalNotification(fireDate: Date,
                              identifier: String,
                              alertTitle: String! = nil,
                              alertBody: String! = nil,
                              alertAction: String! = nil,
                              alertLaunchImage: String! = nil,
                              soundName: String! = nil,
                              userInfo: [AnyHashable : Any]! = nil,
                              repeatInterval: JLRepeatInterval) -> Void {
        
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            if alertTitle != nil {
                content.title = alertTitle
            }
            if alertBody != nil {
                content.body = alertBody
            }
            if alertAction != nil {
            }
            if alertLaunchImage != nil {
                content.launchImageName = alertLaunchImage
            }
            if soundName != nil {
                content.sound = UNNotificationSound(named: soundName)
            }else {
                content.sound = UNNotificationSound.default()
            }
            if userInfo != nil {
                content.userInfo = userInfo
            }
            let trigger = repeatForIOS10(fireDate: fireDate, repeatInterval: repeatInterval)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.add(request, withCompletionHandler: { (error: Error!) in
                
            })
        }else {
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
            var info: Dictionary<AnyHashable,Any> = ["identifier":identifier]
            if userInfo != nil {
                for e in userInfo {
                    info[e.key] = userInfo[e.key]
                }
            }
            localNoti.userInfo = info
            if repeatInterval != .None {
                localNoti.repeatInterval = repeatForIOS8(fireDate: fireDate, repeatInterval: repeatInterval)
            }
            
            UIApplication.shared.scheduleLocalNotification(localNoti)
        }
    }
    
    /// 移除本地通知
    ///
    /// - Parameter identifier: 标识符
    func removeLocalNotification(identifier: String) -> Void {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [identifier])
            center.removeDeliveredNotifications(withIdentifiers: [identifier])
        }else {
            if let locals = UIApplication.shared.scheduledLocalNotifications {
                for localNoti in locals {
                    if let dict = localNoti.userInfo {
                        if dict.keys.contains("identifier") && dict["identifier"] is String && (dict["identifier"] as! String) == identifier {
                            UIApplication.shared.cancelLocalNotification(localNoti)
                        }
                    }
                }
            }
        }
    }
    
    /// 移除所有本地通知
    func removeAllLocalNotification() -> Void {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()
            center.removeAllDeliveredNotifications()
        }else {
            UIApplication.shared.cancelAllLocalNotifications()
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
}
