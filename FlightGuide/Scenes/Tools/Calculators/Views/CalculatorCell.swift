//
//  CalculatorCell.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 06.07.2023.
//

import UIKit

class CalculatorCell: UITableViewCell {
    
    static let identifier = String(describing: MessageCell.self)
    
    var model: Calculator? {
        didSet {
            titleLabel.text = model?.title
        }
    }
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let jumpToImageView = UIImageView(image: .chevron_right,
                                              contentMode: .scaleAspectFit,
                                              tintColor: .flg_secondary_gray)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.addSubviews(titleLabel, jumpToImageView)
        
        containerView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
        }
        titleLabel.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview().inset(10)
            $0.right.lessThanOrEqualTo(jumpToImageView.snp.left).inset(-15)
        }
        jumpToImageView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
    }

    private func setupAppearance() {
        containerView.backgroundColor = .flg_light_dark_white
        containerView.layer.cornerRadius = 10
        backgroundColor = .clear
        
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = .flg_primary_dark
        titleLabel.numberOfLines = 0
        
        selectionStyle = .none
    }
    
}
