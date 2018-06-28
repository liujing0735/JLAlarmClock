//
//  JLAlarmClockUtility.swift
//  JLAlarmClock
//
//  Created by JasonLiu on 2018/6/28.
//  Copyright © 2018年 JasonLiu. All rights reserved.
//

import UIKit

class JLAlarmClockUtility: NSObject {
    
}

func fontName() {
    let familyNames = UIFont.familyNames
    for familyName in familyNames {
        let fontNames = UIFont.fontNames(forFamilyName: familyName)
        for fontName in fontNames {
            print("\(familyName): \(fontName)")
        }
    }
}

func repeatsName(repeatInterval: JLRepeatInterval, weekdaySelect: JLWeekdaySelect!) -> String {
    switch repeatInterval {
    case .None:
        return "只响一次"
    case .Day:
        return "每天"
    case .Weekday:
        if weekdaySelect.isSun == false && weekdaySelect.isMon == true && weekdaySelect.isTue == true && weekdaySelect.isWed == true && weekdaySelect.isThu == true && weekdaySelect.isFri == true && weekdaySelect.isSat == false {
            return "每周 工作日"
        }else {
            var dateString = "每周"
            if weekdaySelect.isMon {
                dateString += " 周一"
            }
            if weekdaySelect.isTue {
                dateString += " 周二"
            }
            if weekdaySelect.isWed {
                dateString += " 周三"
            }
            if weekdaySelect.isThu {
                dateString += " 周四"
            }
            if weekdaySelect.isFri {
                dateString += " 周五"
            }
            if weekdaySelect.isSat {
                dateString += " 周六"
            }
            if weekdaySelect.isSun {
                dateString += " 周天"
            }
            return dateString
        }
    case .Month:
        return "每月"
    case .Year:
        return "每年"
    case .Hour:
        return "每小时"
    }
}
