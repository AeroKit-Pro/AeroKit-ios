//
//  SearchTextField.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 01.04.2023.
//

import UIKit
import RxCocoa
import RxSwift

final class SearchFieldView: UIView, UITextFieldDelegate {
    
    private let magnifierImage = UIImageView(image: .magnifier,
                                             contentMode: .scaleAspectFit,
                                             tintColor: .flg_secondary_gray)
    private let showFiltersButton = UIButton(image: .filters,
                                             contentMode: .scaleAspectFit,
                                             tintColor: .flg_secondary_blue)
    private let dismissButton = UIButton(image: .chevron_left,
                                         contentMode: .scaleAspectFit,
                                         tintColor: .flg_secondary_gray)
    private let imageStackView = UIStackView(axis: .horizontal)
    private let buttonStackView = UIStackView(axis: .horizontal)
    private let spacerImage = UIView()
    private let spacerButton = UIView()
    private let textField = UITextField()
    
    var textFieldDidBeginEditing: ControlEvent<()> {
        textField.rx.controlEvent(.editingDidBegin)
    }
    
    var textFieldDidEndEditing: ControlEvent<()> {
        textField.rx.controlEvent(.editingDidEnd)
    }
    
    var textDidChange: ControlProperty<String?> {
        textField.rx.text
    }
    
    init(frame: CGRect = .zero, placeholder: String = "") {
        super.init(frame: frame)
        setupAppearance()
        setupSubviews()
        setupStackViews()
        setupDismissAction()
        configureTextField()
        textField.placeholder = placeholder
        textField.delegate = self
    }
    
    private func setupAppearance() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor
        backgroundColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 2
    }
    
    private func setupSubviews() {
        addSubview(textField)
        addSubview(showFiltersButton)
        textField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().inset(20)
            $0.right.equalTo(showFiltersButton.snp.left)
        }
        showFiltersButton.snp.makeConstraints {
            $0.width.equalTo(30)
            $0.right.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview()
        }
    }
    
    private func setupStackViews() {
        imageStackView.addArrangedSubviews(magnifierImage, spacerImage)
        spacerImage.snp.makeConstraints { $0.width.equalTo(10) }
        buttonStackView.addArrangedSubviews(dismissButton, spacerButton)
        spacerButton.snp.makeConstraints { $0.width.equalTo(10) }
        
        magnifierImage.snp.makeConstraints { $0.width.equalTo(25) }
        dismissButton.snp.makeConstraints { $0.width.equalTo(25) }
    }
    
    private func setupDismissAction() {
        dismissButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
    }
    
    private func configureTextField() {
        textField.leftView = imageStackView
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
    }
    
    @objc private func dismiss(_ sender: UIButton) {
        textField.resignFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.leftView = buttonStackView
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.leftView = imageStackView
    }
    
    func resignFocus() {
        textField.resignFirstResponder()
    }
    
    func addBorder(withDuration duration: CGFloat) {
        UIView.animate(withDuration: duration) {
            self.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
    
    func removeBorder(withDuration duration: CGFloat) {
        UIView.animate(withDuration: duration) {
            self.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    func addShadow(withDuration duration: CGFloat) {
        UIView.animate(withDuration: duration) {
            self.layer.shadowColor = UIColor.black.cgColor
        }
    }
    
    func removeShadow(withDuration duration: CGFloat) {
        UIView.animate(withDuration: duration) {
            self.layer.shadowColor = UIColor.clear.cgColor
        }
    }
    
}
