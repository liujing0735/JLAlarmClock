//
//  JLAlarmClockSettingTableViewController.swift
//  JLAlarmClock
//
//  Created by JasonLiu on 2017/8/3.
//  Copyright © 2017年 JasonLiu. All rights reserved.
//

import UIKit
import PGDatePicker

class JLAlarmClockSettingTableViewController: JLBaseTableViewController,PGDatePickerDelegate,JLRepeatDelegate {

    var time: String!
    var date: String!
    var week: String!
    var alertTitle: String!
    var alertBody: String!
    var alertAction: String!
    var alertLaunchImage: String!
    var soundName: String!
    
    var datePicker: PGDatePicker = PGDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth(), height: 260))
    var datePickerManager: PGDatePickManager!
    var dateComponents: DateComponents = Calendar.current.dateComponents([.year,.month,.weekday,.weekdayOrdinal,.day,.hour,.minute,.second], from: Date())
    var weekdaySelect: JLWeekdaySelect!
    var repeatUnit: JLRepeatUnit!
    var rowTitles: [String] = ["","闹钟标题","开始日期","响铃周期","铃声选择","更多设置"]
    var rowValue: [String:String] = [:]
    
    private func setupDatePicker() {
        datePicker.delegate = self
        datePicker.datePickerMode = .timeAndSecond
        datePicker.datePickerType = .type2
        datePicker.autoSelected = true
    }
    
    private func setupDatePickManager() {
        datePickerManager = PGDatePickManager()
        datePickerManager.isShadeBackgroud = true
        let datePicker = datePickerManager.datePicker!
        datePicker.delegate = self
        datePicker.datePickerMode = .date
        datePicker.datePickerType = .type2
        datePicker.isHiddenMiddleText = false
        
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)
        datePicker.setDate(date)
        
        self.present(datePickerManager, animated: false, completion: nil)
    }
    
    private func gotoAlarmClockRepeat() {
        let controller = JLAlarmClockRepeatTableViewController()
        controller.delegate = self
        if weekdaySelect != nil {
            controller.weekdaySelect = weekdaySelect
        }
        if repeatUnit != nil {
            controller.repeatUnit = repeatUnit
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func rightItemClick(sender: Any) {
        let sqlMgr = JLSQLiteManager.shared
        if sqlMgr.open() {
            let column: [String: JLSQLiteDataType] = ["alarm_clock_id": .Integer, "alarm_clock_name": .Text, "alarm_clock_time": .Real, "alarm_clock_start_date": .Real, "alarm_clock_cycle_number": .Integer, "alarm_clock_cycle_unit": .Integer]
            let constraint: [String: [JLSQLiteConstraint]] = ["alarm_clock_id": [.AutoPrimaryKey]]
            sqlMgr.createTable(tbName: "alarm_table", tbColumn: column, tbConstraint: constraint) { (error) in
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "添加闹钟"
        addLeftItem(title: "返回")
        addRightItem(title: "存储")
        
        setupDatePicker()
        
        rowValue["闹钟标题"] = "起床闹钟"
        rowValue["开始日期"] = "\(dateComponents.year!)年\(dateComponents.month!)月\(dateComponents.day!)日"
        rowValue["响铃周期"] = "只响一次"

        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDelegate,UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowTitles.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 260
        }
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifer = "cell"
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifer)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: identifer)
        }

        // Configure the cell...
        if indexPath.row == 0 {
            cell.contentView.addSubview(datePicker)
            cell.accessoryType = .none
        }else {
            cell.textLabel?.text = rowTitles[indexPath.row]
            cell.detailTextLabel?.text = rowValue[rowTitles[indexPath.row]]
            cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch rowTitles[indexPath.row] {
        case "闹钟标题":
            break
        case "开始日期":
            setupDatePickManager()
            break
        case "响铃周期":
            gotoAlarmClockRepeat();
            break
        default:
            break
        }
    }
    
    private func weekdayName(weekday: Int) -> String {
        switch weekday {
        case 1:
            return "星期天"
        case 2:
            return "星期一"
        case 3:
            return "星期二"
        case 4:
            return "星期三"
        case 5:
            return "星期四"
        case 6:
            return "星期五"
        case 7:
            return "星期六"
        default:
            return ""
        }
    }
    
    // MARK: - PGDatePickerDelegate
    func datePicker(_ datePicker: PGDatePicker!, didSelectDate dateComponents: DateComponents!) {
        
        if datePicker == self.datePicker {
            print(dateComponents.hour!, dateComponents.minute!, dateComponents.second!)
            self.dateComponents.hour = dateComponents.hour
            self.dateComponents.minute = dateComponents.minute
            self.dateComponents.second = dateComponents.second
        }else {
            print(dateComponents.year!, dateComponents.month!, dateComponents.day!)
            self.dateComponents.year = dateComponents.year
            self.dateComponents.month = dateComponents.month
            self.dateComponents.day = dateComponents.day
            
            let dateString = "\(dateComponents.year!)年\(dateComponents.month!)月\(dateComponents.day!)日"
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy年MM月dd日"
            let date = formatter.date(from: dateString)
            let calendar = Calendar.current
            let tempDateComponents = calendar.dateComponents([.year,.month,.weekday,.weekdayOrdinal,.day,.hour,.minute,.second], from: date!)
            self.dateComponents.weekday = tempDateComponents.weekday
            
            rowValue["开始日期"] = dateString
            self.tableView.reloadData()
        }
    }

    // MARK: - JLRepeatDelegate
    func didSelectRepeat(repeatUnit: JLRepeatUnit, weekdaySelect: JLWeekdaySelect!) {
        
        self.repeatUnit = repeatUnit
        self.weekdaySelect = weekdaySelect
        
        switch repeatUnit {
        case .None:
            rowValue["响铃周期"] = "只响一次"
            break
        case .EveryDay:
            rowValue["响铃周期"] = "每天"
            break
        case .EveryWeek:
            if weekdaySelect.isSun == false && weekdaySelect.isMon == true && weekdaySelect.isTue == true && weekdaySelect.isWed == true && weekdaySelect.isThu == true && weekdaySelect.isFri == true && weekdaySelect.isSat == false {
                rowValue["响铃周期"] = "每周 工作日"
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
                rowValue["响铃周期"] = dateString
            }
            break
        case .EveryMonth:
            rowValue["响铃周期"] = "每月"
            break
        case .EveryYear:
            rowValue["响铃周期"] = "每年"
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
