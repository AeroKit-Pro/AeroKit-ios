//
//  ChecklistInspectionTableCell.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 7.06.23.
//

import UIKit

final class ChecklistInspectionTableCell: UITableViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hex(0xF8F8F8)
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = UIColor.hex(0x333333)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .right
        return label
    }()


    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(containerView)

        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(64)
        }

        containerView.addSubviews(titleLabel, valueLabel)

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }

        valueLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
        }
    }

    func configure(title: String, value: String, isSelected: Bool) {
        titleLabel.text = title
        valueLabel.text = value
        containerView.layer.borderColor = isSelected ? UIColor.black.cgColor : UIColor.clear.cgColor
    }
}
