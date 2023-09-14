//
//  SocialAuthorizationBlockView.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 18.06.23.
//

import UIKit

final class SocialAuthorizationBlockView: UIView {
    let appleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "signUp_appleLogo"), for: .normal)
        return button
    }()

    let gooogleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "signUp_googleLogo"), for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        let leadingSeparatorView = createSeparatorView()
        addSubview(leadingSeparatorView)
        leadingSeparatorView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
        }

        let trailingSeparatorView = createSeparatorView()
        addSubview(trailingSeparatorView)
        trailingSeparatorView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-30)
            make.width.equalTo(leadingSeparatorView)
        }

        let orTitleLabel = UILabel()
        orTitleLabel.text = "or"
        orTitleLabel.font = .systemFont(ofSize: 16)
        orTitleLabel.textColor = .hex(0x979797)
        addSubview(orTitleLabel)
        orTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalTo(16)
            make.leading.equalTo(leadingSeparatorView.snp.trailing).offset(10)
            make.trailing.equalTo(trailingSeparatorView.snp.leading).offset(-10)
            make.centerY.equalTo(leadingSeparatorView)
            make.centerY.equalTo(trailingSeparatorView)
        }

        let buttonsContainer = UIView()
        addSubviews(buttonsContainer)
        buttonsContainer.snp.makeConstraints { make in
            make.height.equalTo(55)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(orTitleLabel.snp.bottom).offset(30)
        }
        buttonsContainer.addSubviews(appleButton, gooogleButton)
        appleButton.snp.makeConstraints { make in
            make.leading.bottom.top.equalToSuperview()
            make.size.equalTo(55)
        }
        gooogleButton.snp.makeConstraints { make in
            make.size.equalTo(55)
            make.trailing.bottom.top.equalToSuperview()
            make.leading.equalTo(appleButton.snp.trailing).offset(30)
        }
    }

    private func createSeparatorView() -> UIView {
        let view = UIView()
        view.snp.makeConstraints { make in
            make.height.equalTo(2)
        }
        view.backgroundColor = .hex(0x979797)
        return view
    }
}
