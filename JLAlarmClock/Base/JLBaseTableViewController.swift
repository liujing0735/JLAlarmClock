//
//  JLBaseTableViewController.swift
//  JLAlarmClock
//
//  Created by JasonLiu on 2018/2/3.
//  Copyright © 2018年 JasonLiu. All rights reserved.
//

import UIKit

class JLBaseTableViewController: JLBaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView: UITableView!
    
    var tableViewStyle: UITableViewStyle {
        set {
            if _tableViewStyle != newValue {
                _tableViewStyle = newValue
                setupTableView()
                setupTapGesture()
            }
        }
        get {
            return _tableViewStyle
        }
    }
    var _tableViewStyle: UITableViewStyle = .plain
    
    func hideKeyboard() {
        //
    }
    
    private func setupTableView() {
        if self.tableView != nil {
            self.tableView.removeFromSuperview()
        }
        self.tableView = UITableView(frame: CGRect(), style: self.tableViewStyle)
        self.tableView.tableFooterView = UIView()
        self.view.addSubview(self.tableView)
        
        updateTableViewFrame()
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.cancelsTouchesInView = false
        if self.tableView != nil {
            self.tableView.addGestureRecognizer(tapGesture)
        }
    }
    
    private func updateTableViewFrame() {
        if #available(iOS 11.0, *) {
            let top = self.view.safeAreaInsets.top
            let bottom = self.view.safeAreaInsets.bottom
            let left = self.view.safeAreaInsets.left
            let right = self.view.safeAreaInsets.right
            
            if isIPhoneX() {
                self.tableView.frame = CGRect(x: left, y: 44 + 44 + top, width: screenWidth - left - right, height: screenHeight - (44 + 44 + top) - bottom)
            }else {
                self.tableView.frame = CGRect(x: left, y: 20 + 44 + top, width: screenWidth - left - right, height: screenHeight - (20 + 44 + top) - bottom)
            }
        }else {
            let parent: AnyObject! = self.parent
            if parent != nil && parent is UITabBarController {
                self.tableView.frame = CGRect(x: 0, y: 20 + 44, width: screenWidth, height: screenHeight - (20 + 44 + 49))
            }else {
                self.tableView.frame = CGRect(x: 0, y: 20 + 44, width: screenWidth, height: screenHeight - (20 + 44))
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
        setupTapGesture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDelegate,UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
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
