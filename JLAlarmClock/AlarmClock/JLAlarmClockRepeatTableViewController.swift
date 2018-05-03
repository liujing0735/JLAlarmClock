//
//  JLAlarmClockRepeatTableViewController.swift
//  JLAlarmClock
//
//  Created by JasonLiu on 2018/2/5.
//  Copyright © 2018年 JasonLiu. All rights reserved.
//

import UIKit

/// 结构体
struct JLWeekdaySelect {
    var isSun: Bool = false
    var isMon: Bool = false
    var isTue: Bool = false
    var isWed: Bool = false
    var isThu: Bool = false
    var isFri: Bool = false
    var isSat: Bool = false

    var string: String {
        set {
            if newValue.count == 7 {
                let values = newValue.strings()
                isSun = Bool(exactly: NSNumber(value: Int(values[0])!))!
                isMon = Bool(exactly: NSNumber(value: Int(values[1])!))!
                isTue = Bool(exactly: NSNumber(value: Int(values[2])!))!
                isWed = Bool(exactly: NSNumber(value: Int(values[3])!))!
                isThu = Bool(exactly: NSNumber(value: Int(values[4])!))!
                isFri = Bool(exactly: NSNumber(value: Int(values[5])!))!
                isSat = Bool(exactly: NSNumber(value: Int(values[6])!))!
            }
        }
        get {
            return "\((isSun ? "1" : "0"))\((isMon ? "1" : "0"))\((isTue ? "1" : "0"))\((isWed ? "1" : "0"))\((isThu ? "1" : "0"))\((isFri ? "1" : "0"))\((isSat ? "1" : "0"))"
        }
    }
}

/// 枚举
///
/// - None: 未选择
/// - EveryYear: 每年
/// - EveryMonth: 每月
/// - EveryWeek: 每周
/// - EveryDay: 每天
enum JLRepeatUnit: Int {
    case None = 0
    case EveryYear
    case EveryMonth
    case EveryWeek
    case EveryDay
}

protocol JLRepeatDelegate {
    func didSelectRepeat(repeatUnit: JLRepeatUnit, weekdaySelect: JLWeekdaySelect!)
}

class JLAlarmClockRepeatTableViewController: JLBaseTableViewController {

    var delegate: JLRepeatDelegate!
    
    var weekdaySelect: JLWeekdaySelect {
        set {
            _weekdaySelect = newValue
        }
        get {
            return _weekdaySelect
        }
    }
    private var _weekdaySelect: JLWeekdaySelect = JLWeekdaySelect()
    var repeatUnit: JLRepeatUnit {
        set {
            _repeatUnit = newValue
        }
        get {
            return _repeatUnit
        }
    }
    private var _repeatUnit: JLRepeatUnit = .None
    private let rowDatas: [[String]] = [["只响一次"],["每天"],["每周一","每周二","每周三","每周四","每周五","每周六","每周天"],["每月"],["每年"]]

    override func rightItemClick(sender: Any) {
        if self.delegate != nil {
            self.delegate.didSelectRepeat(repeatUnit: repeatUnit, weekdaySelect: weekdaySelect)
        }
        backParentViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "响铃周期"
        addLeftItem(title: "返回")
        addRightItem(title: "确定")
        
        self.tableViewStyle = .grouped
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDelegate,UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return rowDatas.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowDatas[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifer = "cell"
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifer)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifer)
        }
        
        // Configure the cell...
        let datas = rowDatas[indexPath.section]
        cell.textLabel?.text = datas[indexPath.row]
        
        switch indexPath.section {
        case 0:
            if repeatUnit == .None {
                cell.accessoryType = .checkmark
            }else {
                cell.accessoryType = .none
            }
            break
        case 1:
            if repeatUnit == .EveryDay {
                cell.accessoryType = .checkmark
            }else {
                cell.accessoryType = .none
            }
            break
        case 2:
            if repeatUnit == .EveryDay {
                cell.accessoryType = .checkmark
            }else if repeatUnit == .EveryWeek {
                switch indexPath.row {
                case 0:
                    if weekdaySelect.isMon {
                        cell.accessoryType = .checkmark
                    }else {
                        cell.accessoryType = .none
                    }
                    break
                case 1:
                    if weekdaySelect.isTue {
                        cell.accessoryType = .checkmark
                    }else {
                        cell.accessoryType = .none
                    }
                    break
                case 2:
                    if weekdaySelect.isWed {
                        cell.accessoryType = .checkmark
                    }else {
                        cell.accessoryType = .none
                    }
                    break
                case 3:
                    if weekdaySelect.isThu {
                        cell.accessoryType = .checkmark
                    }else {
                        cell.accessoryType = .none
                    }
                    break
                case 4:
                    if weekdaySelect.isFri {
                        cell.accessoryType = .checkmark
                    }else {
                        cell.accessoryType = .none
                    }
                    break
                case 5:
                    if weekdaySelect.isSat {
                        cell.accessoryType = .checkmark
                    }else {
                        cell.accessoryType = .none
                    }
                    break
                case 6:
                    if weekdaySelect.isSun {
                        cell.accessoryType = .checkmark
                    }else {
                        cell.accessoryType = .none
                    }
                    break
                default:
                    break
                }
            }else {
                cell.accessoryType = .none
            }
            break
        case 3:
            if repeatUnit == .EveryMonth {
                cell.accessoryType = .checkmark
            }else {
                cell.accessoryType = .none
            }
            break
        case 4:
            if repeatUnit == .EveryYear {
                cell.accessoryType = .checkmark
            }else {
                cell.accessoryType = .none
            }
            break
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let select: Bool = !((tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark) ? true : false)

        switch indexPath.section {
        case 0:
            repeatUnit = .None
            weekdaySelect.isSun = false
            weekdaySelect.isMon = false
            weekdaySelect.isTue = false
            weekdaySelect.isWed = false
            weekdaySelect.isThu = false
            weekdaySelect.isFri = false
            weekdaySelect.isSat = false
            break
        case 1:
            if select {
                repeatUnit = .EveryDay
                weekdaySelect.isSun = true
                weekdaySelect.isMon = true
                weekdaySelect.isTue = true
                weekdaySelect.isWed = true
                weekdaySelect.isThu = true
                weekdaySelect.isFri = true
                weekdaySelect.isSat = true
            }else {
                repeatUnit = .None
                weekdaySelect.isSun = false
                weekdaySelect.isMon = false
                weekdaySelect.isTue = false
                weekdaySelect.isWed = false
                weekdaySelect.isThu = false
                weekdaySelect.isFri = false
                weekdaySelect.isSat = false
            }
            break
        case 2:
            if select {
                repeatUnit = .EveryWeek
                switch indexPath.row {
                case 0:
                    weekdaySelect.isMon = true
                    break
                case 1:
                    weekdaySelect.isTue = true
                    break
                case 2:
                    weekdaySelect.isWed = true
                    break
                case 3:
                    weekdaySelect.isThu = true
                    break
                case 4:
                    weekdaySelect.isFri = true
                    break
                case 5:
                    weekdaySelect.isSat = true
                    break
                case 6:
                    weekdaySelect.isSun = true
                    break
                default:
                    break
                }
                if weekdaySelect.isSun == true && weekdaySelect.isMon == true && weekdaySelect.isTue == true && weekdaySelect.isWed == true && weekdaySelect.isThu == true && weekdaySelect.isFri == true && weekdaySelect.isSat == true {
                    repeatUnit = .EveryDay
                }
            }else {
                repeatUnit = .EveryWeek
                switch indexPath.row {
                case 0:
                    weekdaySelect.isMon = false
                    break
                case 1:
                    weekdaySelect.isTue = false
                    break
                case 2:
                    weekdaySelect.isWed = false
                    break
                case 3:
                    weekdaySelect.isThu = false
                    break
                case 4:
                    weekdaySelect.isFri = false
                    break
                case 5:
                    weekdaySelect.isSat = false
                    break
                case 6:
                    weekdaySelect.isSun = false
                    break
                default:
                    break
                }
                if weekdaySelect.isSun == false && weekdaySelect.isMon == false && weekdaySelect.isTue == false && weekdaySelect.isWed == false && weekdaySelect.isThu == false && weekdaySelect.isFri == false && weekdaySelect.isSat == false {
                    repeatUnit = .None
                }
            }
            break
        case 3:
            if select {
                repeatUnit = .EveryMonth
                weekdaySelect.isSun = false
                weekdaySelect.isMon = false
                weekdaySelect.isTue = false
                weekdaySelect.isWed = false
                weekdaySelect.isThu = false
                weekdaySelect.isFri = false
                weekdaySelect.isSat = false
            }else {
                repeatUnit = .None
            }
            break
        case 4:
            if select {
                repeatUnit = .EveryYear
                weekdaySelect.isSun = false
                weekdaySelect.isMon = false
                weekdaySelect.isTue = false
                weekdaySelect.isWed = false
                weekdaySelect.isThu = false
                weekdaySelect.isFri = false
                weekdaySelect.isSat = false
            }else {
                repeatUnit = .None
            }
            break
        default:
            break
        }
        self.tableView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
