//
//  PresentationUnderlay.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 08.04.2023.
//

import UIKit
// TODO: define a good naming - transition to forst position from Airports VC is seen as "collapse"
final class BannerUnderlayView: UIView {
    
    enum Position: Int {
        case hidden
        case peeking
        case halfVisible
        case fullScreen

        func switchToHigher() -> Position {
            guard let higherPosition = Position(rawValue: self.rawValue + 1) else { return self }
            return higherPosition
        }
        
        func switchToLower() -> Position {
            guard let lowerPosition = Position(rawValue: self.rawValue - 1) else { return self }
            return lowerPosition
        }
    }
    
    var hiddenOffset: CGFloat = 0
    var peekingOffset: CGFloat = 0
    var halfVisibleOffset: CGFloat = 0
    var fullScreenOffset: CGFloat = 0
    
    private(set) var state: Position = .halfVisible {
        didSet {
            switch state {
            case .hidden: expansionConstraint.constant = hiddenOffset
            case .peeking: expansionConstraint.constant = -peekingOffset
            case .halfVisible: expansionConstraint.constant = -halfVisibleOffset
            case .fullScreen: expansionConstraint.constant = -fullScreenOffset
            }
        }
    }
    
    private var expansionConstraint: NSLayoutConstraint!
    
    override func didMoveToSuperview() {
        guard let superview = superview else { return }
        setupConstraints(superview)
        defineOffsets(superview)
        setupRecognizer()
    }
    
    func setToUppermostPosition() {
        state = .fullScreen
    }
    
    func setToHalfScreenPosition() {
        state = .halfVisible
    }
    
    func hide() {
        state = .hidden
    }
    
    private func setupConstraints(_ superview: UIView) {
        expansionConstraint = topAnchor.constraint(equalTo: superview.bottomAnchor)
        expansionConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            heightAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.heightAnchor)
        ])
    }
    
    private func defineOffsets(_ superview: UIView) {
        hiddenOffset = superview.bounds.height
        peekingOffset = superview.boundsSafeHeight * 0.12
        halfVisibleOffset = superview.boundsSafeHeight * 0.3
        fullScreenOffset = superview.boundsSafeHeight
    }
    
    private func setupRecognizer() {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        addGestureRecognizer(recognizer)
    }
        
    private func animate() {
        UIView.animate(withDuration: AnimationDuration.microSlow.timeInterval,
                       delay: 0.0,
                       options: [.allowUserInteraction],
                       animations: {
            self.superview?.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc private func didPan(_ recognizer: UIPanGestureRecognizer) {
        guard let view = recognizer.view else { return }
        let translation = recognizer.translation(in: view)
        
        if recognizer.state == .changed {
            let expansion = max(expansionConstraint.constant + translation.y, -fullScreenOffset)
            expansionConstraint.constant = min(expansion, -peekingOffset)
            recognizer.setTranslation(.zero, in: view)
        }
        
        if recognizer.state == .ended {
            let verticalVelocity = recognizer.velocity(in: view).y
            if verticalVelocity >= 0.0 {
                let lowerState = state.switchToLower()
                guard lowerState != .hidden else { return }
                state = lowerState
            } else {
                state = state.switchToHigher()
            }
            animate()
        }
    }
    
}
