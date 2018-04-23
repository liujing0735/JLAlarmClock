//
//  JLAlarmClockTableViewCell.swift
//  JLAlarmClock
//
//  Created by JasonLiu on 2017/8/4.
//  Copyright © 2017年 JasonLiu. All rights reserved.
//

import UIKit

enum AlarmClock {
    case alarm_icon_getup
    case alarm_icon_birthday
}

class JLAlarmClockTableViewCell: UITableViewCell {
    
    private let timeLabel = UILabel()
    private let titleLabel = UILabel()
    private let detailLabel = UILabel()
    private let alarmClockSwitch = UISwitch()
    private let singleLine = UIView()
    
    func reloadData(dict: Dictionary<String, Any>) {
        let timeString = dict["alarm_clock_time"] as! String
        let times = timeString.components(separatedBy: " ")[1].components(separatedBy: ":")
        timeLabel.text = "\(times[0]):\(times[1])"
        titleLabel.text = dict["alarm_clock_name"] as? String
        detailLabel.text = timeString.components(separatedBy: " ")[0]
        alarmClockSwitch.isOn = Bool(exactly: dict["alarm_clock_state"] as! NSNumber)!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        timeLabel.frame = CGRect(x: 10, y: (60-31)/2, width: 60, height: 31)
        timeLabel.textColor = UIColor.gray
        timeLabel.font = UIFont.systemFont(ofSize: 21)
        self.addSubview(timeLabel)
        
        titleLabel.frame = CGRect(x: 60+20, y: 10, width: 151, height: 20)
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        self.addSubview(titleLabel)
        
        detailLabel.frame = CGRect(x: 60+20, y: 10+20, width: 151, height: 20)
        detailLabel.textColor = UIColor.lightGray
        detailLabel.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(detailLabel)

        alarmClockSwitch.frame = CGRect(x: UIScreen.main.bounds.width-51-10, y: (60-31)/2, width: 51, height: 31)
        self.addSubview(alarmClockSwitch)
        
        singleLine.frame = CGRect(x: 0, y: 60-0.2, width: UIScreen.main.bounds.width, height: 0.2)
        singleLine.backgroundColor = UIColor.lightGray
        self.addSubview(singleLine)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
