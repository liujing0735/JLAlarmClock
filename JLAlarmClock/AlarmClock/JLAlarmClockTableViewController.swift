//
//  JLAlarmClockTableViewController.swift
//  JLAlarmClock
//
//  Created by JasonLiu on 2017/8/4.
//  Copyright © 2017年 JasonLiu. All rights reserved.
//

import UIKit

class JLAlarmClockTableViewController: JLBaseTableViewController {
    
    var alarmClocks: [Dictionary<String, Any>] = []
    
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
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let sqlMgr = JLSQLiteManager.shared
        if sqlMgr.open() {
            sqlMgr.select(tbName: "alarm_clock_info_table", block: { (dicts, error) in
                if error != nil {
                    log((error?.errmsg)!)
                }else {
                    alarmClocks = dicts
                    self.tableView.reloadData()
                }
            })
            sqlMgr.close()
        }
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
        return alarmClocks.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! JLAlarmClockTableViewCell

        // Configure the cell...
        let dict = alarmClocks[indexPath.row]
        cell.reloadData(dict: dict)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let setting = JLAlarmClockSettingTableViewController()
        setting.dataSource = alarmClocks[indexPath.row]
        self.navigationController?.pushViewController(setting, animated: true)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除闹钟"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
        }
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
