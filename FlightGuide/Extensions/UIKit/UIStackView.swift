//
//  UIStackView.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 02.04.2023.
//

import class UIKit.UIStackView
import class UIKit.UIView
import class UIKit.NSLayoutConstraint


extension UIStackView {
    func addArrangedSubviews(_ subviews: UIView...) {
        subviews.forEach { addArrangedSubview($0) }
    }
}

extension UIStackView {
    convenience init(axis: NSLayoutConstraint.Axis) {
        self.init()
        self.axis = axis
    }
}
