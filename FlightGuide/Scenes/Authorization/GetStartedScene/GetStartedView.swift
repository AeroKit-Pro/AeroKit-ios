//
//  GetStartedView.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 18.06.23.
//

import UIKit

final class GetStartedView: UIView {
    var onTapLogin: (() -> Void)?
    var onTapSignUp: (() -> Void)?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 48, weight: .semibold)
        label.text = "AeroKit"
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .hex(0x959595)
        label.text = "Find airports & build your flight"
        return label
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "aerokit_logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.setTitle("Sign up", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    private let logInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .hex(0xF1F1F1)
        button.layer.cornerRadius = 10
        button.setTitle("Log in", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .thin)
        button.setTitleColor(.black, for: .normal)
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
        addSubviews(imageView, titleLabel, subtitleLabel, signUpButton, logInButton)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
            make.size.equalTo(125)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }

        logInButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(10)
            make.leading.trailing.equalToSuperview().inset(45)
            make.height.equalTo(50)
        }

        signUpButton.snp.makeConstraints { make in
            make.bottom.equalTo(logInButton.snp.top).offset(-20)
            make.leading.trailing.equalToSuperview().inset(45)
            make.height.equalTo(50)
        }
    }

    private func setupUI() {
        backgroundColor = .white
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        logInButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
    }

    @objc
    private func didTapLoginButton() {
        onTapLogin?()
    }

    @objc
    private func didTapSignUpButton() {
        onTapSignUp?()
    }
}
