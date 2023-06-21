//
//  MessageCell.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 11.06.2023.
//

import UIKit
import SnapKit

final class MessageCell: UITableViewCell {
    
    static let identifier = String(describing: MessageCell.self)
    
    private let containerView = UIView()
    private let messageLabel = UILabel()
    private let timeLabel = UILabel()
    
    var viewModel: MessageCellViewModel? {
        didSet {
            containerView.backgroundColor = viewModel?.backgroundColor
            messageLabel.text = viewModel?.message
            timeLabel.text = viewModel?.createdAt
            setupRoledLayout(role: viewModel?.role)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupRoledLayout(role: Role?) {
        contentView.addSubview(containerView)
        containerView.addSubviews(messageLabel, timeLabel)
        
        containerView.snp.remakeConstraints {
            switch role {
            case .user:
                $0.right.equalToSuperview().inset(5)
            case .assistant:
                $0.left.equalToSuperview().inset(5)
            default: break
            }
            
            $0.bottom.top.equalToSuperview().inset(5)
            $0.width.lessThanOrEqualTo(contentView.snp.width).multipliedBy(0.85)
        }
        
        messageLabel.snp.makeConstraints {
            $0.right.left.top.equalToSuperview().inset(8)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(3)
            $0.bottom.equalToSuperview().inset(3)
            $0.right.equalToSuperview().inset(5)
            $0.left.greaterThanOrEqualToSuperview().inset(5)
        }
    }
    
    private func setupAppearance() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        containerView.layer.cornerRadius = 10
        
        messageLabel.textColor = .black
        messageLabel.font = .systemFont(ofSize: 16)
        messageLabel.numberOfLines = 0
        
        timeLabel.textColor = UIColor.hex(0x959595)
        timeLabel.font = .systemFont(ofSize: 10)
        
        isUserInteractionEnabled = false
    }
    
}
