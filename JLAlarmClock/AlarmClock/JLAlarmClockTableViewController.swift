//
//  JLAlarmClockTableViewController.swift
//  JLAlarmClock
//
//  Created by JasonLiu on 2017/8/4.
//  Copyright © 2017年 JasonLiu. All rights reserved.
//

import UIKit

class JLAlarmClockTableViewController: JLBaseTableViewController {
    
    override func leftItemClick(sender: Any) {
        
    }
    
    override func rightItemClick(sender: Any) {
        let controller = JLAlarmClockSettingTableViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "闹钟"
        addRightItem(title: "添加")

        self.tableView.separatorStyle = .none
        self.tableView.register(JLAlarmClockTableViewCell.classForCoder(), forCellReuseIdentifier: "reuseIdentifier")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableViewDelegate,UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! JLAlarmClockTableViewCell

        // Configure the cell...
        cell.timeLabel.text = "07:10"
        cell.titleLabel.text = "下午开会"
        cell.detailLabel.text = "2017-08-10 星期四"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let setting = JLAlarmClockSettingTableViewController()
        setting.alertTitle = "下午开会"
        setting.time = "07:10"
        setting.date = "2017-08-10"
        setting.week = "星期四"
        self.navigationController?.pushViewController(setting, animated: true)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
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
