//
//  UIView+Fadeable.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 24.06.2023.
//

import UIKit

protocol Fadeable {
    func fadeOut(withDuration duration: AnimationDuration)
    func fadeIn(withDuration duration: AnimationDuration)
}

extension Fadeable where Self: UIView {
    func fadeOut(withDuration duration: AnimationDuration) {
        UIView.animate(withDuration: duration.timeInterval) {
            self.alpha = 0.0
        }
    }
    
    func fadeIn(withDuration duration: AnimationDuration) {
        UIView.animate(withDuration: duration.timeInterval) {
            self.alpha = 1.0
        }
    }
}
