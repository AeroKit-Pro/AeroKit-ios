//
//  UIImage.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 30.03.2023.
//

import class UIKit.UIImage

extension UIImage {
    static var filters: UIImage? {
        UIImage(named: "filters")
    }
    
    static var magnifier: UIImage? {
        UIImage(named: "magnifier")
    }
    
    static var cross: UIImage? {
        UIImage(named: "cross")
    }
    
    static var chevron_left: UIImage? {
        UIImage(systemName: "chevron.left")
    }
    
    static var pin: UIImage? {
        UIImage(named: "red_pin")
    }
    
    static var airport: UIImage? {
        UIImage(named: "airport")
    }
}
