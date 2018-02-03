//
//  JLTimePickerView.swift
//  JLAlarmClock
//
//  Created by JasonLiu on 2017/8/3.
//  Copyright © 2017年 JasonLiu. All rights reserved.
//

import UIKit

class JLTimePickerView: UIPickerView,UIPickerViewDelegate,UIPickerViewDataSource {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.showsSelectionIndicator = true
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    /*
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
    }
    */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 24
        case 1:
            return 60
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    /*
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return String(format:"%02d",row)
        case 1:
            return String(format:"%02d",row)
        default:
            return ""
        }
    }
    */
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let titleView = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        titleView.text = String(format:"%02d",row)
        titleView.font = UIFont.systemFont(ofSize: 51)
        titleView.adjustsFontSizeToFitWidth = true
        titleView.textAlignment = .center
        return titleView
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
