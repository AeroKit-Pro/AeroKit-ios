//
//  UIButton.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 02.04.2023.
//

import class UIKit.UIButton
import class UIKit.UIImage
import class UIKit.UIImageView
import class UIKit.UIColor

extension UIButton {
    convenience init(image: UIImage?, contentMode: UIImageView.ContentMode, tintColor: UIColor) {
        self.init()
        setImage(image, for: .normal)
        imageView?.contentMode = contentMode
        imageView?.tintColor = tintColor
    }
}
