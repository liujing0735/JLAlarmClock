//
//  JLAlarmClockInputTitleViewController.swift
//  JLAlarmClock
//
//  Created by JasonLiu on 2018/4/23.
//  Copyright © 2018年 JasonLiu. All rights reserved.
//

import UIKit

protocol JLInputTitleDelegate {
    func didInputTitle(title: String)
}

class JLAlarmClockInputTitleViewController: JLBaseTableViewController {

    var delegate: JLInputTitleDelegate!
    var alarmClockTitle: String!
    
    private var textField: UITextField!
    private func setupTextField() {
        textField = UITextField(frame: CGRect(x: 20, y: 0, width: screenWidth-40, height: 44))
        textField.placeholder = "起床闹钟"
        if alarmClockTitle != nil {
            textField.text = alarmClockTitle
        }
    }
    
    override func rightItemClick(sender: Any) {
        if delegate != nil {
            if textField.text != "" {
                delegate.didInputTitle(title: textField.text!)
            }
        }
        backParentViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "闹钟标题"
        addLeftItem(title: "返回")
        addRightItem(title: "确定")
        
        setupTextField()
        
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifer = "cell"
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifer)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: identifer)
        }
        
        // Configure the cell...
        cell.contentView.addSubview(textField)
        cell.accessoryType = .none
        
        return cell
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
