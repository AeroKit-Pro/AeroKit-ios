//
//  NoPasteTextField.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 12.05.2023.
//

import UIKit
/// "NoPasteTextField" disables pasting
final class NoPasteTextField: UITextField {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            if action == #selector(UIResponderStandardEditActions.paste(_:)) {
                return false
            }
            return super.canPerformAction(action, withSender: sender)
        }
    
}
