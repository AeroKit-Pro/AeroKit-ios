//
//  CityCell.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 30.05.2023.
//

import UIKit

final class CityCell: UITableViewCell {
    
    static let identifier = String(describing: CityCell.self)

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var airportTypesStackView: UIStackView!
    @IBOutlet weak var containerView: UIView!
    
    var viewModel: CityCellViewModel? {
        didSet {
            name.text = viewModel?.name
            viewModel?.typeCountStrings
                .forEach { airportTypesStackView
                .addArrangedSubview(UILabel(text: $0, font: .systemFont(ofSize: 12), textColor: .black)) }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
    
    override func prepareForReuse() {
        airportTypesStackView.removeArrangedSubviews()
    }
    
}
