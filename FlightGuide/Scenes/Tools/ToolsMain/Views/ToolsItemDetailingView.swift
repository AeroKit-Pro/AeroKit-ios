//
//  ToolsItemView.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 01.06.23.
//

import UIKit

final class ToolsItemDetailingView: UIView {
    enum ItemType {
        case checklists
        case pdfReader
        case calculators
        
        var titleText: String {
            switch self {
            case .checklists: return "Checklists"
            case .pdfReader: return "PDF Reader"
            case .calculators: return "Calculators"
            }
        }
        
        var subtitleText: String {
            switch self {
            case .checklists: return "Last checked:"
            case .pdfReader: return "Last readed:"
            case .calculators: return "Last used:"
            }
        }
        
        var image: UIImage? {
            switch self {
            case .checklists: return UIImage(named: "tools_checklists")
            case .pdfReader: return UIImage(named: "tools_pdfReader")
            case .calculators: return UIImage(named: "tools_calculators")
            }
        }
        
    }
    
    private let gestureRecognizer = UITapGestureRecognizer()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let imageView = UIImageView()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hex(0x333333).withAlphaComponent(0.5)
        return view
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .thin)
        label.textColor = UIColor.hex(0x959595)
        return label
    }()
    
    private let stackView = UIStackView(axis: .vertical, spacing: 4)
    
    private let itemType: ItemType
    private let onTapAction: (() -> Void)?
    
    init(itemType: ItemType, onTapAction: (() -> Void)?) {
        self.itemType = itemType
        self.onTapAction = onTapAction
        super.init(frame: .zero)
        setupLayout()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateSubitems(items: [ToolsSubitemView]) {
        stackView.removeArrangedSubviews()
        items.forEach { stackView.addArrangedSubview($0) }
    }
    
    @objc private func handleTap() {
        guard let onTapAction else { return }
        onTapAction()
    }
    
    private func setupLayout() {
        addSubviews(titleLabel, imageView, separatorView, subtitleLabel, stackView)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(10)
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(24)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
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
        
    }
    
    private func setupUI() {
        backgroundColor = UIColor.hex(0xF1F1F1)
        layer.cornerRadius = 10
        
        titleLabel.text = itemType.titleText
        subtitleLabel.text = itemType.subtitleText
        imageView.image = itemType.image
        
        gestureRecognizer.addTarget(self, action: #selector(handleTap))
        addGestureRecognizer(gestureRecognizer)
    }

}
