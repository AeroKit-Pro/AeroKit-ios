//
//  UIColor.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 02.04.2023.
//

import class UIKit.UIColor
import struct CoreGraphics.CGFloat

extension UIColor {
    static func hex(_ value: UInt32) -> UIColor {
        let r = CGFloat((value & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((value & 0xFF00) >> 8) / 255.0
        let b = CGFloat(value & 0xFF) / 255.0

        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
      }
}

extension UIColor {
    static var flg_secondary_gray: UIColor {
        UIColor.hex(0x9E9E9E)
    }
    
    static var flg_secondary_blue: UIColor {
        UIColor.hex(0x4682C7)
    }
}
