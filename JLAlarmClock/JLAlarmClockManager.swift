//
//  JLAlarmClockManager.swift
//  JLAlarmClock
//
//  Created by JasonLiu on 2018/2/8.
//  Copyright © 2018年 JasonLiu. All rights reserved.
//

import UIKit

class JLAlarmClockManager: NSObject {
    
    static let shared: JLAlarmClockManager = {
        let sharedInstance = JLAlarmClockManager.init()
        return sharedInstance
    }()
    private override init() {
        super.init()
    }
    
    func addAlarmClock(dict: Dictionary<String, Any>) {
        let repeatsUnit = dict["alarm_clock_repeats_unit"] as! Int
        switch JLRepeatUnit(rawValue: repeatsUnit) {
        case .None:
        {
            addAlarmClockOnlyRangOnce(dict: dict)
        }
            break
        case .EveryYear:
        {
            addAlarmClockEveryYear(dict: dict)
        }
            break
        case .EveryMonth:
        {
            addAlarmClockEveryMonth(dict: dict)
        }
            break
        case .EveryWeek:
        {
            addAlarmClockEveryWeek(dict: dict)
        }
            break
        case .EveryDay:
        {
            addAlarmClockEveryDay(dict: dict)
        }
            break
        }
    }
    
    func addAlarmClockOnlyRangOnce(dict: Dictionary<String, Any>) {
        let localNotMgr = JLLocalNotificationManager.shared
        localNotMgr.registerLocalNotification()
        
        let date: Date = dict["alarm_clock_time"] as! Date
        
        let id: String = dict["alarm_clock_id"] as! String
        let title: String = dict["alarm_clock_title"] as! String
        let content: String = dict["alarm_clock_content"] as! String
        let time: String = dict["alarm_clock_time"] as! String
        let identifier: String = (id + title + content + time).md5
        
        localNotMgr.addLocalNotification(fireDate: date, identifier: identifier, alertTitle: title, repeatInterval: .None)
    }
    
    func addAlarmClockEveryDay(dict: Dictionary<String, Any>) {
        let localNotMgr = JLLocalNotificationManager.shared
        localNotMgr.registerLocalNotification()
        
        let date: Date = dict["alarm_clock_time"] as! Date
        
        let id: String = dict["alarm_clock_id"] as! String
        let title: String = dict["alarm_clock_title"] as! String
        let content: String = dict["alarm_clock_content"] as! String
        let time: String = dict["alarm_clock_time"] as! String
        let identifier: String = (id + title + content + time).md5
        
        localNotMgr.addLocalNotification(fireDate: date, identifier: identifier, alertTitle: title, repeatInterval: .Day)
    }
    
    func addAlarmClockEveryWeek(dict: Dictionary<String, Any>) {
        let localNotMgr = JLLocalNotificationManager.shared
        localNotMgr.registerLocalNotification()
        
        let date: Date = dict["alarm_clock_time"] as! Date
        
        let id: String = dict["alarm_clock_id"] as! String
        let title: String = dict["alarm_clock_title"] as! String
        let content: String = dict["alarm_clock_content"] as! String
        let time: String = dict["alarm_clock_time"] as! String
        let identifier: String = (id + title + content + time).md5
        
        let dates = sevenDaysOfThisWeek(date: date)
        let repeatsWeekday: String = dict["alarm_clock_repeats_weekday"] as! String
        let weekdays = repeatsWeekday.strings()
        for index in 0..<weekdays.count {
            if weekdays[index] == "1" {
                localNotMgr.addLocalNotification(fireDate: dates[index], identifier: identifier+String(format: "%d", index), alertTitle: title, repeatInterval: .Weekday)
            }
        }
    }
    
    func addAlarmClockEveryMonth(dict: Dictionary<String, Any>) {
        let localNotMgr = JLLocalNotificationManager.shared
        localNotMgr.registerLocalNotification()
        
        let date: Date = dict["alarm_clock_time"] as! Date
        
        let id: String = dict["alarm_clock_id"] as! String
        let title: String = dict["alarm_clock_title"] as! String
        let content: String = dict["alarm_clock_content"] as! String
        let time: String = dict["alarm_clock_time"] as! String
        let identifier: String = (id + title + content + time).md5
        
        localNotMgr.addLocalNotification(fireDate: date, identifier: identifier, alertTitle: title, repeatInterval: .Month)
    }
    
    func addAlarmClockEveryYear(dict: Dictionary<String, Any>) {
        let localNotMgr = JLLocalNotificationManager.shared
        localNotMgr.registerLocalNotification()
        
        let date: Date = dict["alarm_clock_time"] as! Date
        
        let id: String = dict["alarm_clock_id"] as! String
        let title: String = dict["alarm_clock_title"] as! String
        let content: String = dict["alarm_clock_content"] as! String
        let time: String = dict["alarm_clock_time"] as! String
        let identifier: String = (id + title + content + time).md5
        
        localNotMgr.addLocalNotification(fireDate: date, identifier: identifier, alertTitle: title, repeatInterval: .Year)
    }
    
    func removeAlarmClock(identifier: String) {
        let localNotMgr = JLLocalNotificationManager.shared
        localNotMgr.removeLocalNotification(identifier: identifier)
    }
    
    /// 7天日期
    ///
    /// - Returns: 指定日期起连续的7天的日期
    func sevenConsecutiveDays(date: Date = Date()) -> [Date] {
        var dates = [Date]()
        for i in 0...6 {
            let timeInterval = TimeInterval(i*24*60*60)
            dates.append(date.addingTimeInterval(timeInterval))
        }
        return dates
    }
    
    /// 7天日期
    ///
    /// - Returns: 指定日期所在周的7天的日期
    func sevenDaysOfThisWeek(date: Date = Date()) -> [Date] {
        var calendar: Calendar = Calendar.current
        calendar.firstWeekday = 2// 设定每周的第一天从星期一开始
        let todayComponents: DateComponents = calendar.dateComponents([.year,.month,.weekday,.weekdayOrdinal,.day,.hour,.minute,.second], from: date)
        let weekday: Int = todayComponents.weekday!
        
        var dates = [Date]()
        if weekday > 1 {
            for i in 1...weekday-1 {
                let timeInterval = TimeInterval((weekday-i)*24*60*60)
                dates.append(date.addingTimeInterval(-timeInterval))
            }
        }
        dates.append(date)
        if weekday < 7 {
            for j in weekday+1...7 {
                let timeInterval = TimeInterval((j-weekday)*24*60*60)
                dates.append(date.addingTimeInterval(timeInterval))
            }
        }
        return dates
    }
    
    /// 本周的工作日
    ///
    /// - Returns: 指定日期所在周的周一到周五的日期
    func workingDayOfThisWeek(date: Date = Date()) -> [Date] {
        var dates = sevenDaysOfThisWeek(date: date)
        if dates.count == 7 {
            dates.remove(at: 5)// 移除周日
            dates.remove(at: 6)// 移除周六
        }
        return dates
    }
}
