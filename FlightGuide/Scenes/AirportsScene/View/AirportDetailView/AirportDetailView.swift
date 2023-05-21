//
//  AirportDetailView.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 09.04.2023.
//

import UIKit

final class AirportDetailView: UIView {

    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var identifier: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var elevation: UILabel!
    @IBOutlet weak var municipality: UILabel!
    @IBOutlet weak var frequency: UILabel!
    @IBOutlet weak var homeLink: UILabel!
    @IBOutlet weak var wikipediaLink: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var runwaysTableView: AutoSizingTableView!
    
    let homeLinkGestureRecognizer = UITapGestureRecognizer()
    let wikipediaLinkGestureRecognizer = UITapGestureRecognizer()
        
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAppearance()
        setupTableView()
        setupHyperlinkLabelsBehaviour()
    }
    
    private func setupAppearance() {
        let shadowPath = UIBezierPath(rect: bounds)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4
        layer.shadowOffset = .zero
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func setupTableView() {
        runwaysTableView.register(UINib(nibName: String(describing: RunwayCell.self), bundle: nil),
                                   forCellReuseIdentifier: RunwayCell.identifier)
        runwaysTableView.dataSource = nil
        runwaysTableView.delegate = nil
        runwaysTableView.separatorStyle = .none
    }
    
    private func setupHyperlinkLabelsBehaviour() {
        homeLink.addGestureRecognizer(homeLinkGestureRecognizer)
        wikipediaLink.addGestureRecognizer(wikipediaLinkGestureRecognizer)
        homeLink.isUserInteractionEnabled = true
        wikipediaLink.isUserInteractionEnabled = true
    }
        
}
