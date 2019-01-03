//
//  UIColor+hex.swift
//  MVVMExample
//
//  Created by Wang Kai on 2018/2/26.
//  Copyright © 2018年 Pirate. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static func colorWithHex(_ hexString: String) -> UIColor {
        let cString = "0x" + hexString
        let aString = cString.cString(using: String.Encoding.utf8)
        let hex = strtoul(aString, nil, 16)
        let divisor = CGFloat(255)
        let red     = CGFloat((hex & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hex & 0x0000FF       ) / divisor
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
