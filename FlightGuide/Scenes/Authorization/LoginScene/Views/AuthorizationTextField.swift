//
//  AuthorizationTextField.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 17.06.23.
//

import UIKit

final class AuthorizationTextFieldContainerView: UIView {

    let stackView = UIStackView(axis: .vertical, spacing: 2)

    let textField: UITextField = {
        let textField = CustomizablePaddingTextField()
        textField.padding = .allSides(5)
        return textField
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .hex(0xD9D9D9)
        return view
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .red
        label.textAlignment = .left
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let containerView = UIView()

        containerView.addSubviews(textField, separatorView)
        textField.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }

        separatorView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom)
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(2)
        }

        stackView.addArrangedSubviews(containerView, errorLabel)
    }

    private func setupUI() {
        textField.delegate = self
    }

    func setState(isError: Bool, errorMessage: String? = nil) {
        errorLabel.isHidden = !isError
        errorLabel.text = errorMessage
    }

    func setPlaceholder(_ placeholder: String) {
        textField.placeholder = placeholder
    }

    func setKeyboardType(_ keyboardType: UIKeyboardType) {
        textField.keyboardType = keyboardType
    }

    func setSecureTextEntry(_ isSecureTextEntry: Bool) {
        textField.isSecureTextEntry = isSecureTextEntry
    }
}

extension AuthorizationTextFieldContainerView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setState(isError: false)
    }
}
