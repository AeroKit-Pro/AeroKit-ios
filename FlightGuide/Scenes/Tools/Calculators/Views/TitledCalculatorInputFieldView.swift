//
//  File.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 03.07.2023.
//

import UIKit

final class TitledCalculatorInputFieldView: UIView {
    
    private let model: TitledCalculatorInputFieldModel
    
    private let stackView = UIStackView(axis: .horizontal)
    private let titleLabel = UILabel()
    private let inputField = NoPasteTextField()
    private let underlineView = UIView()
    
    init(with model: TitledCalculatorInputFieldModel) {
        self.model = model
        super.init(frame: .zero)
        inputField.delegate = self
        setupLayout()
        setupAppearance()
        inputField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        model.onBiderictionalEdtiting = { [weak self] input in
            guard let self else { return }
            self.inputField.text = input
        }
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func becomeReponder() {
        inputField.becomeFirstResponder()
    }
    
    private func setupLayout() {
        addSubviews(stackView, underlineView)
        stackView.addArrangedSubviews(titleLabel, inputField)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
        inputField.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(50)
        }
        underlineView.snp.makeConstraints {
            $0.top.equalTo(inputField.snp.bottom)
            $0.left.right.equalTo(inputField)
            $0.height.equalTo(1)
        }
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

    private func setupAppearance() {
        titleLabel.text = model.title
        titleLabel.textColor = .flg_primary_dark
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        inputField.textAlignment = .center
        inputField.keyboardType = .decimalPad
        underlineView.backgroundColor = .flg_primary_dark
    }
    
    @objc private func editingChanged(_ sender: UITextField) {
        model.action?(sender.text)
    }
    
}

extension TitledCalculatorInputFieldView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: ".0123456789")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
