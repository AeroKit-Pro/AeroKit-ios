//
//  UIEdgeInsets.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 04.06.2023.
//

import UIKit

extension UIEdgeInsets {
    static func allSides(_ padding: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
}
