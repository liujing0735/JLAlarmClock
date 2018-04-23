//
//  JLAlarmClockInputContentViewController.swift
//  JLAlarmClock
//
//  Created by JasonLiu on 2018/4/23.
//  Copyright © 2018年 JasonLiu. All rights reserved.
//

import UIKit

class JLAlarmClockInputContentViewController: JLBaseTableViewController {

    override func rightItemClick(sender: Any) {
        backParentViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "闹钟内容"
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
