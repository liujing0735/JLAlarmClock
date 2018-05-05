//
//  JLExtensionSwift.swift
//  JLExtension-Swift
//
//  Created by JasonLiu on 2017/5/19.
//  Copyright © 2017年 JasonLiu. All rights reserved.
//

import UIKit

func isIPhoneX() -> Bool {
    if screenWidth() == 375 && screenHeight() == 812 {
        return true
    }
    return false
}

func rgb(r: Float, g: Float, b: Float) -> UIColor {
    return rgba(r: r, g: g, b: b, a: 1.0)
}

func rgba(r: Float, g: Float, b: Float, a: Float) -> UIColor {
    if #available(iOS 10.0, *) {
        return UIColor(displayP3Red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: CGFloat(a))
    } else {
        // Fallback on earlier versions
        return UIColor.init(red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: CGFloat(a))
    }
}

func screenWidth() -> CGFloat {
    return UIScreen.main.bounds.size.width
}

func screenHeight() -> CGFloat {
    return UIScreen.main.bounds.size.height
}

func log(_ items: Any..., separator: String = " ", terminator: String = "\n", line: Int = #line, file: String = #file, functoin: String = #function) {
    print("\n在源文件\(String(file.components(separatedBy: "/").last!)) 第\(line)行 \(functoin)函数中: \(items)", separator, terminator)
}

var timeStampString: String {
    get {
        let now = Date()
        let timeInterval = now.timeIntervalSince1970
        let timeStamp = String(timeInterval)
        return timeStamp
    }
}

var timeStampInt: Int {
    get {
        let now = Date()
        let timeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return timeStamp
    }
}

extension Int {
    var toString: String {
        return "\(self)"
    }
}

extension String {
    
    var toInt: Int {
        return Int(self)!
    }
    
    /// 截取子字符串
    ///
    /// - Parameters:
    ///   - start: 起始位置
    ///   - length: 字符长度
    /// - Returns: 子字符串
    func subString(start: Int = 0, length: Int = 0) -> String {
        var len = length
        if len == -1 {
            len = self.count - start
        }
        let st = self.index(startIndex, offsetBy: start)
        let en = self.index(st, offsetBy: len)
        return String(self[st ..< en])
    }
    
    /// 分割字符串
    ///
    /// - Returns: 单字符数组
    func strings() -> [String] {
        var array: [String] = []
        for i in 0 ..< self.count {
            array.append(self.subString(start: i, length: 1))
        }
        return array
    }
    
    var md5: String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize(count: digestLen)
        
        return String(format: hash as String)
    }
}

extension Dictionary {
    
    func anyForKey(key: String) -> Any! {
        let dict: Dictionary<String, Any> = self as! Dictionary<String, Any>
        let keys: [String] = [String](dict.keys)
        if keys.contains(key) {
            return dict[key]
        }
        return nil
    }
    
    func dateForKey(key: String, format: String = "yyyy-MM-dd HH:mm:ss") -> Date {
        let value = anyForKey(key: key)
        if value != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format
            let date: Date = dateFormatter.date(from: value as! String)!
            return date
        }
        return Date()
    }
    
    func stringForKey(key: String) -> String {
        let value = anyForKey(key: key)
        if value != nil {
            if value is String {
                return value as! String
            }
            if value is Int {
                return "\(value as! Int)"
            }
        }
        return ""
    }
    
    func intForKey(key: String) -> Int {
        let value = anyForKey(key: key)
        if value != nil {
            if value is String {
                return Int(value as! String)!
            }
            if value is Int {
                return value as! Int
            }
        }
        return 0
    }
    
    func boolForKey(key: String) -> Bool {
        let value = anyForKey(key: key)
        if value != nil {
            if value is Int {
                return Bool(exactly: value as! NSNumber)!
            }
            if value is Bool {
                return value as! Bool
            }
        }
        return false
    }
}
