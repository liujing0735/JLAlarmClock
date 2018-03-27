//
//  JLCalendarTableViewController.swift
//  JLAlarmClock
//
//  Created by JasonLiu on 2017/8/15.
//  Copyright © 2017年 JasonLiu. All rights reserved.
//

import UIKit
import FSCalendar

class JLCalendarTableViewController: JLBaseTableViewController {

    var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "日历"
        calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: screenWidth(), height: 300))
        
        let center = JLLocalNotificationCenter()
        center.registerLocalNotification()
        
        let dateString = "20180202194230"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let date = formatter.date(from: dateString)
        
        center.addLocalNotification(fireDate: date!, identifier: "identifier", alertTitle: "alertTitle", alertBody: "alertBody", alertAction: nil, alertLaunchImage: nil, soundName: nil, userInfo: nil, repeatInterval: .Hour)
        
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 300
        }
        return 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "TableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        cell?.selectionStyle = .none
        
        if indexPath.row == 0 {
            cell?.contentView.addSubview(calendar)
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
