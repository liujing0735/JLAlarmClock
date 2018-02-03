//
//  JLAlarmClockSettingViewController.swift
//  JLAlarmClock
//
//  Created by JasonLiu on 2017/8/3.
//  Copyright © 2017年 JasonLiu. All rights reserved.
//

import UIKit

class JLAlarmClockSettingViewController: UIViewController {
    
    var time: String!
    var date: String!
    var week: String!
    var alertTitle: String! {
        set {
            self.title = newValue
        }
        get {
            return self.title
        }
    }
    var alertBody: String!
    var alertAction: String!
    var alertLaunchImage: String!
    var soundName: String!
    
    let timePicker = JLTimePickerView(frame: CGRect(x: 0, y: 64, width: screenWidth(), height: 260))

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        view.addSubview(timePicker)
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
