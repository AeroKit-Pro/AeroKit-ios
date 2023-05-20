//
//  PresentationUnderlay.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 08.04.2023.
//

import UIKit
// TODO: define a good naming - transition to forst position from Airports VC is seen as "collapse"
final class BannerUnderlayView: UIView {
    
    enum State {
        case expanded
        case collapsed
        case hidden
    }
    
    var expandedOffset: CGFloat = 0
    
    var collapsedOffset: CGFloat = 0
    
    var hiddenOffset: CGFloat = 0
    
    private(set) var state: State = .collapsed {
        didSet {
            switch state {
            case .expanded: expansionConstraint.constant = -expandedOffset
            case .collapsed: expansionConstraint.constant = -collapsedOffset
            case .hidden: expansionConstraint.constant = hiddenOffset
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
    
    func expand() {
        state = .expanded
    }
    
    func collapse() {
        state = .collapsed
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
            heightAnchor.constraint(equalToConstant: superview.bounds.height - 200)
        ])
    }
    
    private func defineOffsets(_ superview: UIView) {
        expandedOffset = superview.bounds.height * 0.8
        collapsedOffset = superview.bounds.height * 0.3
        hiddenOffset = superview.bounds.height
    }
    
    private func setupRecognizer() {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        addGestureRecognizer(recognizer)
    }
        
    private func animate() {
        UIView.animate(withDuration: 0.3,
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
            // rubber band effect
            if expansionConstraint.constant < -expandedOffset {
                let dampingFactor: CGFloat = 0.2
                let absYPos = abs(expansionConstraint.constant + translation.y)
                let adjustedYPos = expandedOffset * (1 + (log10(absYPos / expandedOffset) * dampingFactor))
                expansionConstraint.constant = -adjustedYPos
                return
            }
            if expansionConstraint.constant >= -collapsedOffset {
                let dampingFactor: CGFloat = 0.2
                let absYPos = abs(expansionConstraint.constant - translation.y)
                let adjustedYPos = collapsedOffset * (1 - (log10(absYPos / collapsedOffset) * dampingFactor))
                expansionConstraint.constant = -adjustedYPos
                return
            }
            // TODO: lower rubber band effect
            expansionConstraint.constant += translation.y
            recognizer.setTranslation(.zero, in: view)
        }
        
        if recognizer.state == .ended {
            let velocity = recognizer.velocity(in: view)
            if velocity.y >= 0.0 {
                state = .collapsed
            } else {
                state = .expanded
            }
            animate()
        }
    }
    
}
