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
    
    /// 连续的7天日期
    ///
    /// - Returns: 从今天起连续的7天的日期
    func sevenConsecutiveDaysFromToday() -> [Date] {
        let today = Date()
        var dates = [Date]()
        for i in 0...6 {
            let timeInterval = TimeInterval(i*24*60*60)
            dates.append(today.addingTimeInterval(timeInterval))
        }
        return dates
    }
    
    /// 本周的日期
    ///
    /// - Returns: 本周周日到周六的日期
    func sevenDateOfThisWeek() -> [Date] {
        let today = Date()
        let calendar: Calendar = Calendar.current
        let todayComponents: DateComponents = calendar.dateComponents([.year,.month,.weekday,.weekdayOrdinal,.day,.hour,.minute,.second], from: today)
        let weekday: Int = todayComponents.weekday!
        
        var dates = [Date]()
        if weekday > 1 {
            for i in 1...weekday-1 {
                let timeInterval = TimeInterval((weekday-i)*24*60*60)
                dates.append(today.addingTimeInterval(-timeInterval))
            }
        }
        dates.append(today)
        if weekday < 7 {
            for j in weekday+1...7 {
                let timeInterval = TimeInterval((j-weekday)*24*60*60)
                dates.append(today.addingTimeInterval(timeInterval))
            }
        }
        return dates
    }
    
    /// 本周的工作日
    ///
    /// - Returns: 本周周一到周五的日期
    func workingDayOfThisWeek() -> [Date] {
        var dates = sevenDateOfThisWeek()
        if dates.count == 7 {
            dates.remove(at: 0)// 移除周日
            dates.remove(at: 6)// 移除周六
        }
        return dates
    }
}
