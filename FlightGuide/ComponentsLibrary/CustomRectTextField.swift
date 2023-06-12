//
//  EditingRectTextField.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 11.06.2023.
//

import UIKit

final class CustomRectTextField: UITextField {
    
    private let insets: UIEdgeInsets
    
    init(rectInsets: UIEdgeInsets, frame: CGRect = .zero) {
        insets = rectInsets
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let editingRect = bounds.inset(by: insets)
        return editingRect
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let editingRect = bounds.inset(by: insets)
        return editingRect
    }
    
}
