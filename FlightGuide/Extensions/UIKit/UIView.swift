//
//  UIView.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 01.04.2023.
//

import UIKit
import struct CoreGraphics.CGRect
import class Foundation.Bundle

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }

    func addSubviewsWithoutAutoresizingMask(_ subviews: UIView...) {
        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}

extension UIView {
    /// prepares view for layout
    static func forAutoLayout<ViewType: UIView>(frame: CGRect = .zero) -> ViewType {
            let view = ViewType.init(frame: frame)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }
}

extension UIView {
    static func fromNib<T: UIView>() -> T {
        let view = Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: self, options: nil)![0] as! T
        return view
    }
}

extension UIView {

    /* This helper method tries to find a subview of the given class. It returns
       the first view found, or nil if none are found. */
    func findSubview(ofType theClass: AnyClass) -> UIView? {
        for subview in self.subviews {
            if subview.isKind(of: theClass) {
                return subview
            }
        }
        return nil
    }

    /* This helper method tries to find all subviews of the given class. It
       returns an array of views, which is empty if none are found. */
    func findSubviews(ofType theClass: AnyClass) -> [UIView] {
        var foundViews = [UIView]()
        for subview in self.subviews {
            if subview.isKind(of: theClass) {
                foundViews.append(subview)
            }
        }
        return foundViews
    }
}

extension UIView {
    /// Changes view's alpha to 1.
    func show(animated: Bool, duration: TimeInterval = AnimationDuration.microSlow.timeInterval, completion: ((Bool) -> Void)? = nil) {
        let withDuration: TimeInterval = animated ? duration : 0
        UIView.animate(withDuration: withDuration, animations: {
            self.alpha = 1
        }, completion: completion)
    }

    /// Changes view's alpha to 0.
    func hide(animated: Bool, duration: TimeInterval = AnimationDuration.microSlow.timeInterval, completion: ((Bool) -> Void)? = nil) {
        let withDuration: TimeInterval = animated ? duration : 0
        UIView.animate(withDuration: withDuration, animations: {
            self.alpha = 0
        }, completion: completion)
    }
}

enum AnimationDuration: TimeInterval {
    /// 0.1 sec
    case microFast = 0.1
    /// 0.2 sec
    case microRegular = 0.2
    /// 0.3 sec
    case microSlow = 0.3

    /// 0.4 sec
    case macroFast = 0.4
    /// 0.5 sec
    /// default animation duration
    case macroRegular = 0.5
    /// 0.6 sec
    case macroSlow = 0.6

    var timeInterval: TimeInterval {
        return rawValue
    }
}

extension UIView {
    ///  returns self's bounds height minus vertical safe area insets
    var boundsSafeHeight: CGFloat {
        bounds.height - safeAreaInsets.top - safeAreaInsets.bottom
    }
}

extension UIView {
    func scalexyBy(_ scale: CGFloat) {
        transform = CGAffineTransform(scaleX: scale, y: scale)
    }
}
