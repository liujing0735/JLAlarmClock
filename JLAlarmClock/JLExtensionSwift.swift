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

func log(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    print("\n在文件:\(String(#file.components(separatedBy: "/").last!))第\(#line)行: \(items)", separator, terminator)
}

class JLExtensionSwift: NSObject {

}
