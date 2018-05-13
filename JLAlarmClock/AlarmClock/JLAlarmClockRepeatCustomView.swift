//
//  JLAlarmClockRepeatCustomView.swift
//  JLAlarmClock
//
//  Created by JasonLiu on 2018/5/13.
//  Copyright © 2018年 JasonLiu. All rights reserved.
//

import UIKit
import PGPickerView
import Segmentio

class JLAlarmClockRepeatCustomView: UIView,PGPickerViewDelegate,PGPickerViewDataSource {
    
    var delegate: JLRepeatDelegate!
    var weekdaySelect: JLWeekdaySelect = JLWeekdaySelect()
    var repeatInterval: JLRepeatInterval = .Hour
    var repeatNumber: Int = 2
    
    // custom view component
    var backgroudView: UIView!
    var backgroudLabel: UILabel!
    
    var foregroundView: UIView!
    var pickerView: PGPickerView!
    var segmentedView: Segmentio!
    
    var segmentIndex: Int = 0
    let repeatTitles: [String] = ["时","天","周","月","年"]
    let repeatIntervals: [JLRepeatInterval] = [.Hour,.Day,.Weekday,.Month,.Year]
    let repeatNumbers: [[String]] = [
        ["2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"],
        ["2","3","4","5","6"],
        ["2","3","4","5"],
        ["2","3","4","5","6","7","8","9","10","11"],
        ["2","3","4","5","6","7","8","9","10","11","12"]]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroudView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        backgroudView.backgroundColor = rgba(r: 0, g: 0, b: 0, a: 0.5)
        self.addSubview(backgroudView)
        
        foregroundView = UIView(frame: CGRect(x: 0, y: frame.height-(260+44), width: frame.width, height: 260+44))
        foregroundView.backgroundColor = .white
        self.addSubview(foregroundView)
        
        pickerView = PGPickerView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 260))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.type = .type1
        pickerView.isHiddenMiddleText = false
        foregroundView.addSubview(pickerView)
        
        var content = [SegmentioItem]()
        for title in repeatTitles {
            let tornadoItem = SegmentioItem(title: title, image: UIImage())
            content.append(tornadoItem)
        }
        segmentedView = Segmentio(frame: CGRect(x: 0, y: 260, width: frame.width, height: 44))
        segmentedView.setup(content: content, style: .onlyLabel, options: nil)
        segmentedView.valueDidChange = { segmentio, segmentIndex in
            print("Selected item: ", segmentIndex)
            self.segmentIndex = segmentIndex
            self.pickerView.reloadAllComponents()
        }
        foregroundView.addSubview(segmentedView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponents(in pickerView: PGPickerView!) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: PGPickerView!, numberOfRowsInComponent component: Int) -> Int {
        return repeatNumbers[segmentIndex].count
    }
    
    func pickerView(_ pickerView: PGPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        return repeatNumbers[segmentIndex][row]
    }
    
    func pickerView(_ pickerView: PGPickerView!, middleTextForcomponent component: Int) -> String! {
        return repeatTitles[segmentIndex]
    }
    
    func pickerView(_ pickerView: PGPickerView!, middleTextSpaceForcomponent component: Int) -> CGFloat {
        return 10
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
