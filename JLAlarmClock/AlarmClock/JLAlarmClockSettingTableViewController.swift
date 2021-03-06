//
//  JLAlarmClockSettingTableViewController.swift
//  JLAlarmClock
//
//  Created by JasonLiu on 2017/8/3.
//  Copyright © 2017年 JasonLiu. All rights reserved.
//

import UIKit
import PGDatePicker

class JLAlarmClockSettingTableViewController: JLBaseTableViewController,PGDatePickerDelegate,JLRepeatDelegate,JLInputTitleDelegate {
    
    var alarmClockDict: Dictionary<String, Any>!
    
    var datePicker: PGDatePicker = PGDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 260))
    var datePickerManager: PGDatePickManager!
    var dateComponents: DateComponents = Calendar.current.dateComponents([.year,.month,.weekday,.weekdayOrdinal,.day,.hour,.minute,.second], from: Date())
    var weekdaySelect: JLWeekdaySelect = JLWeekdaySelect()
    var repeatInterval: JLRepeatInterval = .None
    var rowTitles: [String] = ["","闹钟标题","开始日期","响铃周期","铃声选择","更多设置"]
    var rowValue: [String:String] = [:]
    
    private func setupDatePicker() {
        datePicker.delegate = self
        datePicker.datePickerMode = .time
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
    }
    
    private func showDatePickManager() {
        if datePickerManager == nil {
            setupDatePickManager()
        }
        self.present(datePickerManager, animated: false, completion: nil)
    }
    
    private func gotoAlarmClockRepeat() {
        let controller = JLAlarmClockRepeatTableViewController()
        controller.delegate = self
        controller.weekdaySelect = weekdaySelect
        controller.repeatInterval = repeatInterval
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func gotoAlarmClockInputTitle() {
        let controller = JLAlarmClockInputTitleViewController()
        controller.delegate = self
        if rowValue["闹钟标题"] != "" {
            controller.alarmClockTitle = rowValue["闹钟标题"]
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func rightItemClick(sender: Any) {
        let sqlMgr = JLSQLiteManager.shared
        if sqlMgr.open() {
            let title: String = rowValue["闹钟标题"]!
            let time = String(format: "%04d", dateComponents.year!)+"-"+String(format: "%02d", dateComponents.month!)+"-"+String(format: "%02d", dateComponents.day!)+" "+String(format: "%02d", dateComponents.hour!)+":"+String(format: "%02d", dateComponents.minute!)+":"+String(format: "%02d", dateComponents.second!)
            let data: [String: Any] = ["alarm_clock_name": title,
                "alarm_clock_content": "",
                "alarm_clock_time": time,
                "alarm_clock_repeats_number": 1,
                "alarm_clock_repeats_interval": repeatInterval.rawValue,
                "alarm_clock_repeats_weekday": weekdaySelect.string,
                "alarm_clock_state": 1,
                "user_id": 0,
                "alarm_clock_delete_flag": 0]
            if alarmClockDict == nil {
                sqlMgr.insert(tbName: "alarm_clock_info_table", data: data, block: { (error) in
                    if error != nil {
                        log((error?.errmsg)!)
                    }
                })
            }else {
                sqlMgr.update(tbName: "alarm_clock_info_table", data: data, rowWhere: "alarm_clock_id = "+String(alarmClockDict["alarm_clock_id"] as! Int), block: { (error) in
                    if error != nil {
                        log((error?.errmsg)!)
                    }
                })
            }
            /*
            sqlMgr.select(tbName: "alarm_clock_info_table", block: { (dicts, error) in
                if error != nil {
                    log((error?.errmsg)!)
                }else {
                    log(dicts!)
                }
            })
            sqlMgr.delete(tbName: "alarm_clock_info_table", rowWhere: "alarm_clock_id == 10", block: { (error) in
                
                if error != nil {
                    log((error?.errmsg)!)
                }
            })
            sqlMgr.update(tbName: "alarm_clock_info_table", data: ["alarm_clock_name": "新的起床闹铃"], block: { (error) in
                
                if error != nil {
                    log((error?.errmsg)!)
                }
            })
            */
            sqlMgr.close()
        }
        backParentViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addLeftItem(title: "返回")
        addRightItem(title: "存储")
        
        setupDatePicker()
        setupDatePickManager()
        
        if alarmClockDict == nil {
            self.title = "添加闹钟"
            
            rowValue["闹钟标题"] = "起床闹钟"
            rowValue["开始日期"] = "\(dateComponents.year!)年\(dateComponents.month!)月\(dateComponents.day!)日"
            rowValue["响铃周期"] = "只响一次"
        }else {
            self.title = "设置闹钟"
            
            rowValue["闹钟标题"] = (alarmClockDict["alarm_clock_name"] as! String)
            
            let dateString = alarmClockDict["alarm_clock_time"] as! String
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = formatter.date(from: dateString)
            let calendar: Calendar = Calendar.current
            let components: DateComponents = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date!)
            datePicker.setDate(date)
            datePickerManager.datePicker.setDate(date)
            rowValue["开始日期"] = "\(components.year!)年\(components.month!)月\(components.day!)日"
            
            repeatInterval = JLRepeatInterval(rawValue: alarmClockDict["alarm_clock_repeats_interval"] as! Int)!
            weekdaySelect.string = (alarmClockDict["alarm_clock_repeats_weekday"] as! String)
            rowValue["响铃周期"] = repeatsName(repeatInterval: repeatInterval, weekdaySelect: weekdaySelect)
        }

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
            gotoAlarmClockInputTitle()
            break
        case "开始日期":
            showDatePickManager()
            break
        case "响铃周期":
            gotoAlarmClockRepeat()
            break
        default:
            break
        }
    }
    
    // MARK: - PGDatePickerDelegate
    func datePicker(_ datePicker: PGDatePicker!, didSelectDate dateComponents: DateComponents!) {
        
        if datePicker == self.datePicker {
            //print(dateComponents.hour!, dateComponents.minute!, dateComponents.second!)
            self.dateComponents.hour = dateComponents.hour
            self.dateComponents.minute = dateComponents.minute
            self.dateComponents.second = dateComponents.second
        }else {
            //print(dateComponents.year!, dateComponents.month!, dateComponents.day!)
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
    func didSelectRepeat(repeatInterval: JLRepeatInterval, weekdaySelect: JLWeekdaySelect!, repeatNumber: Int) {
        
        self.repeatInterval = repeatInterval
        self.weekdaySelect = weekdaySelect
        
        rowValue["响铃周期"] = repeatsName(repeatInterval: repeatInterval, weekdaySelect: weekdaySelect)
        
        self.tableView.reloadData()
    }
    
    // MARK: - JLInputTitleDelegate
    func didInputTitle(title: String) {
        rowValue["闹钟标题"] = title
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
