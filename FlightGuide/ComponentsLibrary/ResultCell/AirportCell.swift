//
//  TableViewCell.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 05.04.2023.
//

import UIKit

final class AirportCell: UITableViewCell {
    
    static let identifier = String(describing: AirportCell.self)

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var municipality: UILabel!
    @IBOutlet weak var surface: UILabel!
    
    var viewModel: AirportCellViewModel? {
        didSet {
            self.typeImage.image = viewModel?.image
            self.name.text = viewModel?.title
            self.type.text = viewModel?.type
            self.municipality.text = viewModel?.municipality
            self.surface.text = viewModel?.surface
        }
    }
    
    override func awakeFromNib() {
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        selected ? onSelection() : onDeselection()
    }
    
    private func onSelection() {
        containerView.alpha = 0.8
    }
    
    private func onDeselection() {
        containerView.alpha = 1
    }
    
}
