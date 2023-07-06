//
//  AccountView.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 6.07.23.
//

import FirebaseAuth
import UIKit

final class AccountView: UIView {
    private let emailDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Email:"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        return label
    }()

    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = FirebaseAuth.Auth.auth().currentUser?.email ?? ""
        label.textColor = .hex(0x959595)
        return label
    }()

    let deleteAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete account", for: .normal)
        let color = UIColor.hex(0xE32636)
        button.setTitleColor(color, for: .normal)
        button.backgroundColor = color.withAlphaComponent(0.25)
        button.layer.cornerRadius = 10
        return button
    }()

    init() {
        super.init(frame: .zero)
        setupLayout()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(emailDescriptionLabel)
        emailDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(30)
        }

        addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.leading.equalTo(emailDescriptionLabel.snp.trailing).offset(20)
            make.centerY.equalTo(emailDescriptionLabel)
        }

        addSubview(deleteAccountButton)
        deleteAccountButton.snp.makeConstraints { make in
            make.top.equalTo(emailDescriptionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    private func setupUI() {
    }
}
