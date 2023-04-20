//
//  UIImageView.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 02.04.2023.
//

import class UIKit.UIImageView
import class UIKit.UIColor
import class UIKit.UIImage

extension UIImageView {
    convenience init(image: UIImage?, contentMode: UIImageView.ContentMode, tintColor: UIColor) {
        self.init()
        self.image = image
        self.contentMode = contentMode
        self.tintColor = tintColor
    }
}
