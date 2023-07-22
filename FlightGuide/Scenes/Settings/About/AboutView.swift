//
//  AboutView.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 6.07.23.
//

import UIKit

final class AboutView: UIView {
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "aerokit_logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "AeroKit"
        label.font = .systemFont(ofSize: 48, weight: .semibold)
        label.textColor = .black
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        label.text = "AeroKit Pro Version \(appVersion ?? "")"
        label.textColor = .hex(0x959595)
        return label
    }()

    private let emailToContactDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Email to contact us:"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        return label
    }()

    let emailToContactButton: UIButton = {
        let button = UIButton()
        let yourAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14, weight: .semibold),
                                                             .foregroundColor: UIColor.black,
                                                             .underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(string: InfoURLs.supportEmail,
                                                        attributes: yourAttributes)
        button.setAttributedTitle(attributeString, for: .normal)
        return button
    }()

    let privacyPolicyButton: UIButton = {
        let button = UIButton()
        let yourAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                                                             .foregroundColor: UIColor.black,
                                                             .underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(string: "Privacy Policy",
                                                        attributes: yourAttributes)
        button.setAttributedTitle(attributeString, for: .normal)
        return button
    }()

    let ourWebsiteButton: UIButton = {
        let button = UIButton()
        let yourAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                                                             .foregroundColor: UIColor.black,
                                                             .underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(string: "Our website",
                                                        attributes: yourAttributes)
        button.setAttributedTitle(attributeString, for: .normal)
        return button
    }()

    private let appstoreButton: UIButton = {
        let button = UIButton()
        let yourAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                                                             .foregroundColor: UIColor.black,
                                                             .underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(string: "Appstore",
                                                        attributes: yourAttributes)
        button.setAttributedTitle(attributeString, for: .normal)
        return button
    }()

    private var items = SettingItem.allCases
    var onTapItem: ((SettingItem) -> Void)?
    init() {
        super.init(frame: .zero)
        setupLayout()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(50)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 127, height: 125))
        }

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }

        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }

        let labelsStackView = UIStackView(axis: .horizontal, spacing: 30)
        labelsStackView.addArrangedSubviews(emailToContactDescriptionLabel, emailToContactButton)
        addSubview(labelsStackView)
        labelsStackView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }

        addSubview(privacyPolicyButton)
        privacyPolicyButton.snp.makeConstraints { make in
            make.top.equalTo(labelsStackView.snp.bottom).offset(30)
            make.trailing.equalTo(emailToContactDescriptionLabel)
        }

        addSubview(ourWebsiteButton)
        ourWebsiteButton.snp.makeConstraints { make in
            make.top.equalTo(privacyPolicyButton)
            make.leading.equalTo(emailToContactButton)
        }

        addSubview(appstoreButton)
        appstoreButton.snp.makeConstraints { make in
            make.top.equalTo(privacyPolicyButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }

    private func setupUI() {
    }
}
