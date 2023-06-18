//
//  CustomizablePaddingTextField.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 18.06.23.
//

import UIKit

final class CustomizablePaddingTextField: UITextField {

    var padding = UIEdgeInsets.zero

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
}
