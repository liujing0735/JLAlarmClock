//
//  JLAlarmClockSettingTableViewController.swift
//  JLAlarmClock
//
//  Created by JasonLiu on 2017/8/3.
//  Copyright © 2017年 JasonLiu. All rights reserved.
//

import UIKit

class JLAlarmClockSettingTableViewController: JLBaseTableViewController {
    
    var time: String!
    var date: String!
    var week: String!
    var alertTitle: String!
    var alertBody: String!
    var alertAction: String!
    var alertLaunchImage: String!
    var soundName: String!
    
    let timePicker = JLTimePickerView(frame: CGRect(x: 0, y: 0, width: screenWidth(), height: 260))

    let rowTitles = ["","闹钟标题","开始日期","响铃周期","铃声选择","更多设置"]
    
    override func rightItemClick(sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "添加闹钟"
        addLeftItem(title: "返回")
        addRightItem(title: "存储")

        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
            cell = UITableViewCell(style: .default, reuseIdentifier: identifer)
        }

        // Configure the cell...
        if indexPath.row == 0 {
            cell.contentView.addSubview(timePicker)
        }else {
            cell.textLabel?.text = rowTitles[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
