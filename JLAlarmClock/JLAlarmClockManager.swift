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
        let repeatsUnit: JLRepeatUnit = JLRepeatUnit(rawValue: dict.intForKey(key: "alarm_clock_repeats_unit"))!
        switch repeatsUnit {
        case .None:
            self.addAlarmClockOnlyRangOnce(dict: dict)
            break
        case .EveryYear:
            self.addAlarmClockEveryYear(dict: dict)
            break
        case .EveryMonth:
            self.addAlarmClockEveryMonth(dict: dict)
            break
        case .EveryWeek:
            self.addAlarmClockEveryWeek(dict: dict)
            break
        case .EveryDay:
            self.addAlarmClockEveryDay(dict: dict)
            break
        }
    }
    
    func addAlarmClockOnlyRangOnce(dict: Dictionary<String, Any>) {
        let title = dict.stringForKey(key: "alarm_clock_name")
        let date = dict.dateForKey(key: "alarm_clock_time")
        let identifier = self.identifier(dict: dict)
        
        let localNotMgr = JLLocalNotificationManager.shared
        localNotMgr.registerLocalNotification()
        localNotMgr.addLocalNotification(fireDate: date, identifier: identifier, alertTitle: title, repeatInterval: .None)
    }
    
    func addAlarmClockEveryDay(dict: Dictionary<String, Any>) {
        let title = dict.stringForKey(key: "alarm_clock_name")
        let date = dict.dateForKey(key: "alarm_clock_time")
        let identifier = self.identifier(dict: dict)
        
        let localNotMgr = JLLocalNotificationManager.shared
        localNotMgr.registerLocalNotification()
        localNotMgr.addLocalNotification(fireDate: date, identifier: identifier, alertTitle: title, repeatInterval: .Day)
    }
    
    func addAlarmClockEveryWeek(dict: Dictionary<String, Any>) {
        let localNotMgr = JLLocalNotificationManager.shared
        localNotMgr.registerLocalNotification()
        
        let title = dict.stringForKey(key: "alarm_clock_name")
        let date = dict.dateForKey(key: "alarm_clock_time")
        let identifier = self.identifier(dict: dict)
        
        let dates = sevenDaysOfThisWeek(date: date)
        let repeatsWeekday: String = dict["alarm_clock_repeats_weekday"] as! String
        let weekdays = repeatsWeekday.strings()
        for index in 0..<weekdays.count {
            self.removeAlarmClock(identifier: identifier+String(format: "%d", index))
            if weekdays[index] == "1" {
                localNotMgr.addLocalNotification(fireDate: dates[index], identifier: identifier+String(format: "%d", index), alertTitle: title, repeatInterval: .Weekday)
            }
        }
    }
    
    func addAlarmClockEveryMonth(dict: Dictionary<String, Any>) {
        let title = dict.stringForKey(key: "alarm_clock_name")
        let date = dict.dateForKey(key: "alarm_clock_time")
        let identifier = self.identifier(dict: dict)
        
        let localNotMgr = JLLocalNotificationManager.shared
        localNotMgr.registerLocalNotification()
        localNotMgr.addLocalNotification(fireDate: date, identifier: identifier, alertTitle: title, repeatInterval: .Month)
    }
    
    func addAlarmClockEveryYear(dict: Dictionary<String, Any>) {
        let title = dict.stringForKey(key: "alarm_clock_name")
        let date = dict.dateForKey(key: "alarm_clock_time")
        let identifier = self.identifier(dict: dict)
        
        let localNotMgr = JLLocalNotificationManager.shared
        localNotMgr.registerLocalNotification()
        localNotMgr.addLocalNotification(fireDate: date, identifier: identifier, alertTitle: title, repeatInterval: .Year)
    }
    
    func removeAlarmClock(dict: Dictionary<String, Any>) {
        let identifier = self.identifier(dict: dict)
        
        let repeatsUnit: JLRepeatUnit = JLRepeatUnit(rawValue: dict.intForKey(key: "alarm_clock_repeats_unit"))!
        if repeatsUnit == .EveryWeek {
            let repeatsWeekday = dict.stringForKey(key: "alarm_clock_repeats_weekday")
            let weekdays = repeatsWeekday.strings()
            for index in 0..<weekdays.count {
                self.removeAlarmClock(identifier: identifier+String(format: "%d", index))
            }
        }else {
            self.removeAlarmClock(identifier: identifier)
        }
    }
    
    func removeAlarmClock(identifier: String) {
        let localNotMgr = JLLocalNotificationManager.shared
        localNotMgr.removeLocalNotification(identifier: identifier)
    }
    
    func identifier(dict: Dictionary<String, Any>) -> String {
        let id = dict.stringForKey(key: "alarm_clock_id")
        let name = dict.stringForKey(key: "alarm_clock_name")
        let content = dict.stringForKey(key: "alarm_clock_content")
        let time = dict.stringForKey(key: "alarm_clock_time")

        return (id + name + content + time).md5
    }
    
    /// 连续的7天日期
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
    
    /// 本周的7天日期
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
