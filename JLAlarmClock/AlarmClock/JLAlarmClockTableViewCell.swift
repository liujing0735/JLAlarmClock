//
//  JLAlarmClockTableViewCell.swift
//  JLAlarmClock
//
//  Created by JasonLiu on 2017/8/4.
//  Copyright © 2017年 JasonLiu. All rights reserved.
//

import UIKit

protocol JLAlarmClockTableViewCellDelegate {
    func didClickSwitch(sender: UISwitch)
}

enum JLAlarmClock {
    case alarm_icon_getup
    case alarm_icon_birthday
}

class JLAlarmClockTableViewCell: UITableViewCell {
    
    var delegate: JLAlarmClockTableViewCellDelegate!
    
    private let timeLabel = UILabel()
    private let titleLabel = UILabel()
    private let detailLabel = UILabel()
    private let alarmClockSwitch = UISwitch()
    private let singleLine = UIView()
    
    func reloadData(dict: Dictionary<String, Any>) {
        let timeString = dict["alarm_clock_time"] as! String
        let times = timeString.components(separatedBy: " ")[1].components(separatedBy: ":")
        var temp = "\(times[0]):\(times[1])"
        temp = temp.replacingOccurrences(of: "1", with: " 1")
        timeLabel.text = temp//"\(times[0]):\(times[1])"
        titleLabel.text = dict["alarm_clock_name"] as? String
        
        let repeatInterval = JLRepeatInterval(rawValue: dict["alarm_clock_repeats_interval"] as! Int)
        let weekdaySelect = JLWeekdaySelect(string: dict["alarm_clock_repeats_weekday"] as! String)
        detailLabel.text = repeatsName(repeatInterval: repeatInterval!, weekdaySelect: weekdaySelect)
        alarmClockSwitch.isOn = Bool(exactly: dict["alarm_clock_state"] as! NSNumber)!
    }
    
    @objc func clickSwitch(sender: UISwitch) {
        delegate.didClickSwitch(sender: sender)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        timeLabel.frame = CGRect(x: 10, y: (60-31)/2, width: 75, height: 31)
        timeLabel.textColor = UIColor.gray
        timeLabel.font = UIFont(name: "LetsgoDigital-Regular", size: 26)
        self.addSubview(timeLabel)
        
        titleLabel.frame = CGRect(x: 75+10, y: 10, width: 151, height: 20)
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        self.addSubview(titleLabel)
        
        detailLabel.frame = CGRect(x: 75+10, y: 10+20, width: 151, height: 20)
        detailLabel.textColor = UIColor.lightGray
        detailLabel.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(detailLabel)

        alarmClockSwitch.frame = CGRect(x: UIScreen.main.bounds.width-51-10, y: (60-31)/2, width: 51, height: 31)
        alarmClockSwitch.addTarget(self, action: #selector(clickSwitch(sender:)), for: .valueChanged)
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
