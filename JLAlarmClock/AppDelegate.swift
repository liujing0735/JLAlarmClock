//
//  AppDelegate.swift
//  JLAlarmClock
//
//  Created by JasonLiu on 2017/8/1.
//  Copyright © 2017年 JasonLiu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        firstLaunch()
        
        let alarmClockTable = JLAlarmClockTableViewController()
        alarmClockTable.tabBarItem.title = "闹钟"
        alarmClockTable.tabBarItem.image = UIImage(named: "alarm_icon_getup")
        
        let calendarTable = JLCalendarTableViewController()
        calendarTable.tabBarItem.title = "日历"
        calendarTable.tabBarItem.image = UIImage(named: "alarm_icon_yearly")
        
        let tabBar = JLBaseTabBarController()
        tabBar.viewControllers = [alarmClockTable,calendarTable]
        
        let navigation = UINavigationController(rootViewController: tabBar)
        navigation.setNavigationBarHidden(true, animated: true)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    private func firstLaunch() {
        let databaseVersion = 1.0
        if !UserDefaults.standard.bool(forKey: "firstLaunch") {
            UserDefaults.standard.set(true, forKey: "firstLaunch")
            
            createAlarmClockInfoTable()
            createAlarmClockUserInfoTable()
            createAlarmClockDatabaseVersionTable()
            insertAlarmClockDatabaseVersion(version: databaseVersion)
        }else {
            
            let dbVersion = alarmClockDatabaseVersion()
            if dbVersion != databaseVersion {
                if dbVersion == 1.0 {
                    // 数据库版本更新
                    updateAlarmClockDatabaseVersion(version: databaseVersion)
                }
            }
        }
    }
    
    private func insertAlarmClockDatabaseVersion(version: Double) {
        let sqlMgr = JLSQLiteManager.shared
        if sqlMgr.open() {
            let data: [String: Any] = [
                "db_version_number": version,
                "update_time": timeStampString]
                sqlMgr.insert(tbName: "db_version_table", data: data, block: { (error) in
                    if error != nil {
                        log((error?.errmsg)!)
                    }
                })
            sqlMgr.close()
        }
    }
    
    private func updateAlarmClockDatabaseVersion(version: Double) {
        let sqlMgr = JLSQLiteManager.shared
        if sqlMgr.open() {
            let data: [String: Any] = [
                "db_version_number": version,
                "update_time": timeStampString]
            sqlMgr.update(tbName: "db_version_table", data: data, block: { (error) in
                if error != nil {
                    log((error?.errmsg)!)
                }
            })
            sqlMgr.close()
        }
    }
    
    private func alarmClockDatabaseVersion() -> Double {
        var version = 0.0
        let sqlMgr = JLSQLiteManager.shared
        if sqlMgr.open() {
            sqlMgr.select(tbName: "db_version_table", block: { (dicts, error) in
                if error != nil {
                    log((error?.errmsg)!)
                }else {
                    if dicts.count > 0 {
                        version = dicts[0]["db_version_number"] as! Double
                    }
                }
            })
            sqlMgr.close()
        }
        return version
    }
    
    private func createAlarmClockDatabaseVersionTable() {
        let sqlMgr = JLSQLiteManager.shared
        if sqlMgr.open() {
            let column: [String: JLSQLiteDataType] = [
                "db_version_id": .Integer,
                "db_version_number": .Real,
                "update_time": .Real]
            let constraint: [String: [JLSQLiteConstraint]] = ["db_version_id": [.AutoPrimaryKey]]
            sqlMgr.createTable(tbName: "db_version_table", tbColumn: column, tbConstraint: constraint) { (error) in
                
                if error != nil {
                    log((error?.errmsg)!)
                }
            }
            sqlMgr.close()
        }
    }
    
    private func createAlarmClockUserInfoTable() {
        let sqlMgr = JLSQLiteManager.shared
        if sqlMgr.open() {
            let column: [String: JLSQLiteDataType] = [
                "user_id": .Integer,
                "user_account": .Text,
                "user_password": .Text,
                "user_nickname": .Text,
                "user_icon": .Text,
                "user_name": .Text,
                "user_phone": .Text,
                "user_email": .Text,
                "user_level": .Integer,
                "user_vip": .Integer,
                "update_time": .Real]
            let constraint: [String: [JLSQLiteConstraint]] = ["user_id": [.AutoPrimaryKey]]
            sqlMgr.createTable(tbName: "user_info_table", tbColumn: column, tbConstraint: constraint) { (error) in
                
                if error != nil {
                    log((error?.errmsg)!)
                }
            }
            sqlMgr.close()
        }
    }
    
    private func createAlarmClockInfoTable() {
        let sqlMgr = JLSQLiteManager.shared
        if sqlMgr.open() {
            let column: [String: JLSQLiteDataType] = [
                "alarm_clock_id": .Integer,
                "alarm_clock_name": .Text,
                "alarm_clock_content": .Text,
                "alarm_clock_time": .Real,
                "alarm_clock_repeats_number": .Integer,
                "alarm_clock_repeats_unit": .Integer,
                "alarm_clock_repeats_weekday": .Text,
                "alarm_clock_state": .Integer,
                "alarm_clock_delete_flag": .Integer,
                "user_id": .Integer,
                "update_time": .Real]
            let constraint: [String: [JLSQLiteConstraint]] = ["alarm_clock_id": [.AutoPrimaryKey], "alarm_clock_info_table,user_id": [.ForeignKey]]
            sqlMgr.createTable(tbName: "alarm_clock_info_table", tbColumn: column, tbConstraint: constraint) { (error) in
                
                if error != nil {
                    log((error?.errmsg)!)
                }
            }
            sqlMgr.close()
        }
    }
}

