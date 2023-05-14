//
//  AirportsFilterRunwaysLengthView.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 5.05.23.
//

import UIKit

final class AirportsFilterRunwaysLengthView: UIView {
    private enum Constants {
        static let maxSymbolsCountOfLength = 5
    }
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Min. runway length"
        label.font = .systemFont(ofSize: 20, weight: .semibold) // TODO: fonts
        return label
    }()

    let textField: NoPasteTextField = {
        let textField = NoPasteTextField()
        textField.textAlignment = .right
        textField.font = .systemFont(ofSize: 16)
        textField.keyboardType = .numberPad
        return textField
    }()

    let textFieldUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hex(0x333333)
        return view
    }()

    let measureLabel: UILabel = {
        let label = UILabel()
        label.text = "ft."
        label.font = .systemFont(ofSize: 16) // TODO: fonts
        return label
    }()
    
    var enteredLength: String? {
        textField.text
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubviews(titleLabel, textField, textFieldUnderlineView, measureLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(24)
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }

        measureLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }

        textField.snp.makeConstraints { make in
            make.trailing.equalTo(measureLabel.snp.leading).offset(-5)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
        }

        textFieldUnderlineView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(2)
            make.leading.trailing.equalTo(textField)
            make.height.equalTo(1)
        }
    }

    private func setupUI() {
        backgroundColor = UIColor.hex(0xF8F8F8)
        layer.cornerRadius = 16

        textField.delegate = self
    }
}

// MARK: - UITextFieldDelegate
extension AirportsFilterRunwaysLengthView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= Constants.maxSymbolsCountOfLength
    }
}
