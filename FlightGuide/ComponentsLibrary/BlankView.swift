//
//  BlankView.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 06.04.2023.
//

import UIKit

final class BlankView: UIView {
    
    init(frame: CGRect = .zero, color: UIColor = .white) {
        super.init(frame: frame)
        backgroundColor = color
    }
    
    func show(withDuration duration: CGFloat) {
        isHidden = false
        Self.animate(withDuration: duration,
                     animations: { self.alpha = 1 })
    }
    
    func hide(withDuration duration: CGFloat) {
        Self.animate(withDuration: duration,
                     animations: { self.alpha = 0 },
                     completion: { _ in self.isHidden = true })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
