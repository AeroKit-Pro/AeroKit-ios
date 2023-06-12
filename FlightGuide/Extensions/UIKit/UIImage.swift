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
    
    static var back_arrow: UIImage? {
        UIImage(named: "back_arrow")
    }
    
    static var airport_pin: UIImage? {
        UIImage(named: "airport_pin")
    }

    static var chevron_right: UIImage? {
        UIImage(systemName: "chevron.right")
    }
    
    static var pin: UIImage? {
        UIImage(named: "red_pin")
    }
    
    static var airport: UIImage? {
        UIImage(named: "airport")
    }
    
    static var bookmark_deselected: UIImage? {
        UIImage(named: "bookmark_deselected")
    }
    
    static var bookmark_selected: UIImage? {
        UIImage(named: "bookmark_selected")
    }
    static var aichat: UIImage? {
        UIImage(named: "tools_aichat")
    }
    
    static var checklists: UIImage? {
        UIImage(named: "tools_checklists")
    }
    
    static var pdfReader: UIImage? {
        UIImage(named: "tools_pdfReader")
    }
    
    static var arrow_up: UIImage? {
        UIImage(named: "arrow_up")
    }
}
