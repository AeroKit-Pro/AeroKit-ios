//
//  RunwayCell.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 20.05.2023.
//

import UIKit

final class RunwayCell: UITableViewCell {

    static let identifier = String(describing: RunwayCell.self)
    
    @IBOutlet weak var surface: UILabel!
    @IBOutlet weak var length: UILabel!
    @IBOutlet weak var width: UILabel!
    @IBOutlet weak var lighted: UILabel!
    
    var viewModel: RunwayCellViewModel? {
        didSet {
            self.surface.text = viewModel?.surface
            self.length.text = viewModel?.length
            self.width.text = viewModel?.width
            self.lighted.text = viewModel?.lighted
        }
    }

}
