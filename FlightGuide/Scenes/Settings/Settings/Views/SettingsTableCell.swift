//
//  SettingsTableCell.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 6.07.23.
//

import UIKit

final class SettingsTableCell: UITableViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hex(0xF8F8F8)
        view.layer.cornerRadius = 10
        return view
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = UIColor.hex(0x333333)
        label.numberOfLines = 0
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textColor = UIColor.black
        return label
    }()

    private let labelsContainerView = UIStackView(axis: .vertical, spacing: 2)

    let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "checklists_chevron")
        imageView.contentMode = .scaleAspectFit
        return imageView
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
            make.height.greaterThanOrEqualTo(50)
        }

        containerView.addSubviews(iconImageView, labelsContainerView, chevronImageView)
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
            make.size.equalTo(30)
        }

        labelsContainerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconImageView.snp.trailing).offset(5)

            make.trailing.equalTo(chevronImageView.snp.leading).offset(-10)
        }

        chevronImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
        labelsContainerView.addArrangedSubviews(titleLabel, subtitleLabel)
    }

    func configure(title: String, subtitle: String?, image: UIImage?) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        iconImageView.image = image
    }
}
