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
    ///hex(0xACB3CB)
    static var flg_blue_gray: UIColor {
        UIColor.hex(0xACB3CB)
    }
    ///hex(0x333333)
    static var flg_primary_dark: UIColor {
        UIColor.hex(0x333333)
    }
    ///hex(0xF8F8F8)
    static var flg_light_dark_white: UIColor {
        UIColor.hex(0xF8F8F8)
    }
    ///hex(0xD9E8FF)
    static var flg_light_blue: UIColor {
        UIColor.hex(0xD9E8FF)
    }
    ///hex(0x959595)
    static var flg_secondary_gray: UIColor {
        UIColor.hex(0x959595)
    }
    ///hex(0xD9D9D9)
    static var flg_light_gray: UIColor {
        UIColor.hex(0xD9D9D9)
    }
}
