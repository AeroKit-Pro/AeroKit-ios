//
//  ToolsItemView.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 11.06.2023.
//

import UIKit

final class ToolsItemView: UIView {
    
    enum ItemType {
        case AIChat

        var titleText: String {
            switch self {
            case .AIChat: return "AIChat"
            }
        }
        
        var typeImage: UIImage? {
            switch self {
            case .AIChat: return .aichat
            }
        }
        
        var onTapActionImage: UIImage? {
            switch self {
            case .AIChat: return .chevron_right
            }
        }
    }
    
    private let tapGestureRecognizer = UITapGestureRecognizer()
    
    private let typeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let onTapActionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private let itemType: ItemType
    private let onTapAction: (() -> Void)?

    init(itemType: ItemType, onTapAction: (() -> Void)?) {
        self.itemType = itemType
        self.onTapAction = onTapAction
        super.init(frame: .zero)
        setupLayout()
        setupUI()
        setupAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        onTapAction?()
    }

    private func setupLayout() {
        addSubviews(typeImageView, titleLabel, onTapActionImageView)
        
        typeImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(11)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(typeImageView.snp.right).offset(6)
            make.top.bottom.equalToSuperview().inset(12)
        }
        
        onTapActionImageView.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(10)
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }

        separatorView.snp.makeConstraints { make in
            make.top.equalTo(showButton.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(12)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(10)
        }

        
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

    private func setupUI() {
        backgroundColor = UIColor.hex(0xF1F1F1)
        layer.cornerRadius = 10
        
        titleLabel.text = itemType.titleText
        typeImageView.image = itemType.typeImage
        onTapActionImageView.image = itemType.onTapActionImage
        onTapActionImageView.tintColor = .flg_secondary_gray
    }

    func updateSubitems(items: [ToolsSubitemView]) {
        stackView.removeArrangedSubviews()
        items.forEach { stackView.addArrangedSubview($0) }
    }
    
    private func setupAction() {
        tapGestureRecognizer.addTarget(self, action: #selector(handleTap))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
}
