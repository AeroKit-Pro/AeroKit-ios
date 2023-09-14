//
//  SignUpView.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 15.06.23.
//

import UIKit

final class SignUpView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome!"
        label.font = .systemFont(ofSize: 36, weight: .semibold)
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .hex(0x333333)
        label.text = "Create a new account"
        return label
    }()

    let userNameContainerView: AuthorizationTextFieldContainerView = {
        let containerView = AuthorizationTextFieldContainerView()
        containerView.textField.setAttributedPlaceholder("Username", color: .hex(0x6F6F6F))
        return containerView
    }()

    let emailContainerView: AuthorizationTextFieldContainerView = {
        let containerView = AuthorizationTextFieldContainerView()
        containerView.textField.setAttributedPlaceholder("Email", color: .hex(0x6F6F6F))
        return containerView
    }()

    let passwordContainerView: AuthorizationTextFieldContainerView = {
        let containerView = AuthorizationTextFieldContainerView()
        containerView.textField.setAttributedPlaceholder("Password", color: .hex(0x6F6F6F))
        containerView.setSecureTextEntry(true)
        return containerView
    }()

    let signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.setTitle("Sign up", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let socialAuthorizationBlockView = SocialAuthorizationBlockView()

    init() {
        super.init(frame: .zero)
        setupLayout()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubviews(titleLabel, subtitleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(20)
        }

        addSubviews(userNameContainerView, emailContainerView, passwordContainerView, signUpButton, socialAuthorizationBlockView)

        userNameContainerView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(100 * UIScreen.main.bounds.height / 822)
            make.leading.trailing.equalToSuperview().inset(45)
        }

        emailContainerView.snp.makeConstraints { make in
            make.top.equalTo(userNameContainerView.snp.bottom).offset(35)
            make.leading.trailing.equalTo(userNameContainerView)
        }

        passwordContainerView.snp.makeConstraints { make in
            make.top.equalTo(emailContainerView.snp.bottom).offset(35)
            make.leading.trailing.equalTo(userNameContainerView)
        }

        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(passwordContainerView.snp.bottom).offset(40)
            make.leading.trailing.equalTo(userNameContainerView)
            make.height.equalTo(50)
        }

        socialAuthorizationBlockView.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            make.leading.trailing.equalToSuperview()
        }
    }

    private func setupUI() {
    }
}
