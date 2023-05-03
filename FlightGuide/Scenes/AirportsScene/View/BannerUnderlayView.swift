//
//  PresentationUnderlay.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 08.04.2023.
//

import UIKit

final class BannerUnderlayView: UIView {
    
    enum State {
        case expanded
        case collapsed
    }
    
    private(set) var state: State = .collapsed {
        didSet {
            if oldValue == state { return }
        }
    }
    
    private var expansionConstraint: NSLayoutConstraint!
    private var valueToHide: CGFloat!
    private var upperLimit: CGFloat!
    private var lowerLimit: CGFloat!
    
    override func didMoveToSuperview() {
        guard let superview = superview else { return }
        setupConstraints(superview)
        upperLimit = superview.frame.height * 0.2
        lowerLimit = superview.frame.height * 0.7
    }
        
    func setupConstraints(_ superview: UIView) {
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        addGestureRecognizer(panGestureRecognizer)
        
        expansionConstraint = topAnchor.constraint(equalTo: superview.topAnchor)
        
        valueToHide = superview.frame.height
        expansionConstraint.constant = valueToHide
        expansionConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            heightAnchor.constraint(equalToConstant: superview.frame.height)
        ])
    }
    
    @objc func didPan(_ recognizer: UIPanGestureRecognizer) {
        guard let view = recognizer.view else { return }
        
        let translation = recognizer.translation(in: view)
        
        let expansion = expansionConstraint.constant + translation.y
        let limitedExpansion = min(max(expansion, upperLimit), lowerLimit)
        
        expansionConstraint.constant = limitedExpansion
        recognizer.setTranslation(.zero, in: view)
    }
    
    func expand() {
        expansionConstraint.constant = lowerLimit
    }
    
    func collapse() {
        expansionConstraint.constant = valueToHide
    }
    
}
