//
//  UIView.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 01.04.2023.
//

import class UIKit.UIView
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
