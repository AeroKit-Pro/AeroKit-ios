//
//  UILabel.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 31.05.2023.
//

import UIKit

extension UILabel {
    convenience init(text: String?, font: UIFont, textColor: UIColor, frame: CGRect = .zero) {
        self.init(frame: frame)
        self.text = text
        self.font = font
        self.textColor = textColor
    }
}
