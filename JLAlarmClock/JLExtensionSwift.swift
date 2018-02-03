//
//  JLExtensionSwift.swift
//  JLExtension-Swift
//
//  Created by JasonLiu on 2017/5/19.
//  Copyright © 2017年 JasonLiu. All rights reserved.
//

import UIKit

func rgb(r: Float, g: Float, b: Float) -> UIColor {
    return UIColor.init(colorLiteralRed: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
}

func rgba(r: Float, g: Float, b: Float, a: Float) -> UIColor {
    return UIColor.init(colorLiteralRed: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

func screenWidth() -> CGFloat {
    return UIScreen.main.bounds.size.width
}

func screenHeight() -> CGFloat {
    return UIScreen.main.bounds.size.height
}

func log(log: String) {
    print("\n在文件(%@)第(%d)行: %@",#file,#line,log)
}

class JLExtensionSwift: NSObject {

}
