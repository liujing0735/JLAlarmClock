//
//  JLBaseViewController.swift
//  JLAlarmClock
//
//  Created by JasonLiu on 2018/2/3.
//  Copyright © 2018年 JasonLiu. All rights reserved.
//

import UIKit

@objc protocol JLBaseDelegate {
    @objc optional func leftItemClick(sender: Any)
    @objc optional func rightItemClick(sender: Any)
    @objc optional func hideKeyboard()
}

class JLBaseViewController: UIViewController,JLBaseDelegate {
    
    var statusBarView: UIView!
    var baseNavigationBar: UINavigationBar!
    var baseNavigationItem: UINavigationItem!

    override var title: String? {
        set {
            _title = newValue
            self.baseNavigationItem.title = newValue
        }
        get {
            return _title
        }
    }
    var _title: String!
    
    var navigationBarWidth: CGFloat {
        get {
            if baseNavigationBar != nil {
                return baseNavigationBar.frame.width
            }
            return 0
        }
    }
    
    var navigationBarHeight: CGFloat {
        get {
            if baseNavigationBar != nil {
                if #available(iOS 11.0, *) {
                    if isIPhoneX() {
                        return 44 + 44
                    }
                }
                return 20 + 44
            }
            return 0
        }
    }
    
    private func updateViewFrame() {
        if #available(iOS 11.0, *) {
            let top = self.view.safeAreaInsets.top
            let left = self.view.safeAreaInsets.left
            let right = self.view.safeAreaInsets.right
            
            if isIPhoneX() {
                self.statusBarView.frame = CGRect(x: left, y: 0, width: screenWidth - left - right, height: 44 + top)
                self.baseNavigationBar.frame = CGRect(x: left, y: 44 + top, width: screenWidth - left - right, height: 44)
            }else {
                self.statusBarView.frame = CGRect(x: left, y: 0, width: screenWidth - left - right, height: 20 + top)
                self.baseNavigationBar.frame = CGRect(x: left, y: 20 + top, width: screenWidth - left - right, height: 44)
            }
        }else {
            self.statusBarView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 20)
            self.baseNavigationBar.frame = CGRect(x: 0, y: 20, width: screenWidth, height: 44)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.statusBarView = UIView()
        self.statusBarView.backgroundColor = rgb(r: 249, g: 249, b: 249)
        self.view.addSubview(self.statusBarView)
        
        self.view.backgroundColor = UIColor.white
        self.baseNavigationBar = UINavigationBar()
        self.baseNavigationBar.tintColor = UIColor.black
        self.baseNavigationBar.barTintColor = rgb(r: 249, g: 249, b: 249)
        self.baseNavigationBar.isTranslucent = false
        self.baseNavigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 21)]
        
        self.baseNavigationItem = UINavigationItem()
        self.baseNavigationBar.pushItem(self.baseNavigationItem, animated: true)
        self.view.addSubview(self.baseNavigationBar)
        
        updateViewFrame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 返回父视图控制器
    func backParentViewController() {
        let controllers: [UIViewController]! = self.navigationController?.childViewControllers
        if controllers.count > 0 {
            self.navigationController?.popViewController(animated: true)
        }else {
            self.dismiss(animated: true, completion: {
                
            })
        }
    }
    
    /// 返回根视图控制器
    func backRootViewController() {
        let controllers: [UIViewController]! = self.navigationController?.childViewControllers
        if controllers.count > 0 {
            self.navigationController?.popToRootViewController(animated: true)
        }else {
            self.dismiss(animated: true, completion: {
                
            })
        }
    }

    func leftItemClick(sender: Any) {
        backParentViewController()
    }
    
    func rightItemClick(sender: Any) {
        //
    }
    
    func addLeftItem(title: String) {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.addTarget(self, action: #selector(leftItemClick(sender:)), for: .touchUpInside)
        self.baseNavigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    func addRightItem(title: String) {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.addTarget(self, action: #selector(rightItemClick(sender:)), for: .touchUpInside)
        self.baseNavigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    func addLeftItem(img: UIImage) {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btn.setImage(img, for: .normal)
        btn.addTarget(self, action: #selector(leftItemClick(sender:)), for: .touchUpInside)
        self.baseNavigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    func addRightItem(img: UIImage) {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btn.setImage(img, for: .normal)
        btn.addTarget(self, action: #selector(rightItemClick(sender:)), for: .touchUpInside)
        self.baseNavigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    func removeLeftItem() {
        self.baseNavigationItem.leftBarButtonItem = nil
    }
    
    func removeRightItem() {
        self.baseNavigationItem.rightBarButtonItem = nil
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
