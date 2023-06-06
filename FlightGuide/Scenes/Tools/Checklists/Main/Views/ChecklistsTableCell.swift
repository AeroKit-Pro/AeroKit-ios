//
//  ChecklistsTableCell.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 2.06.23.
//

import UIKit

final class ChecklistsTableCell: UITableViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hex(0xF8F8F8)
        view.layer.cornerRadius = 10
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

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.hex(0x959595)
        return label
    }()

    private let labelsContainerView = UIStackView(axis: .vertical)

    let removeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "checklists_chevron"), for: .normal)
        return button
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

        containerView.addSubviews(labelsContainerView, removeButton)
        labelsContainerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(removeButton.snp.leading).offset(-10)
        }

        removeButton.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
        labelsContainerView.addArrangedSubviews(titleLabel, subtitleLabel)
    }

    func configure(title: String, subtitle: String?, isDeleteMode: Bool) {
        titleLabel.text = title
        if !(subtitle?.isEmpty ?? true) {
            subtitleLabel.text = subtitle
            subtitleLabel.isHidden = false
        } else {
            subtitleLabel.isHidden = true
        }

        let image = UIImage(named: isDeleteMode ? "checklists_trash" : "checklists_chevron")
        removeButton.setImage(image, for: .normal)
        removeButton.isEnabled = isDeleteMode
    }
}
