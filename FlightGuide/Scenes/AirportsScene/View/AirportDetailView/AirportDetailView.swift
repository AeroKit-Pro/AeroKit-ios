//
//  AirportDetailView.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 09.04.2023.
//

import UIKit

class AirportDetailView: UIView {

    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var identifier: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var elevation: UILabel!
    @IBOutlet weak var municipality: UILabel!
    @IBOutlet weak var frequency: UILabel!
    @IBOutlet weak var wikipediaLink: UILabel!
    @IBOutlet weak var homeLink: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let shadowPath = UIBezierPath(rect: bounds)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4
        layer.shadowOffset = .zero
        layer.masksToBounds = false
    }
    
}
