//
//  SearchTextField.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 01.04.2023.
//

import UIKit
import RxCocoa
import RxSwift

final class SearchFieldView: UIView {
    
    var textFieldDidBeginEditing: ControlEvent<()> {
        textField.rx.controlEvent(.editingDidBegin)
    }
    
    var textFieldDidEndEditing: ControlEvent<()> {
        textField.rx.controlEvent(.editingDidEnd)
    }

    var didTapFilterButton: ControlEvent<()> {
        showFiltersButton.rx.controlEvent(.touchUpInside)
    }
    
    var rxTextFieldText: ControlProperty<String?> {
        textField.rx.text
    }
    
    var rxCounterBadge: Reactive<CounterBadge> {
        counterBadge.rx
    }
    
    var rxDismissSearchButton: Reactive<UIButton> {
        dismissButton.rx
    }
        
    private let magnifierImage = UIImageView(image: .magnifier,
                                             contentMode: .scaleAspectFit,
                                             tintColor: .flg_blue_gray)
    private let showFiltersButton = UIButton(image: .filters,
                                             contentMode: .scaleAspectFit)
    private let dismissButton = UIButton(image: .back_arrow,
                                         contentMode: .scaleAspectFit,
                                         tintColor: .flg_primary_dark)
    private let clearTextButton = UIButton(image: .cross,
                                           contentMode: .scaleAspectFit,
                                           tintColor: .flg_primary_dark)
    private let counterBadge = CounterBadge()
    private let imageStackView = UIStackView(axis: .horizontal)
    private let buttonStackView = UIStackView(axis: .horizontal)
    private let spacerImage = UIView()
    private let spacerButton = UIView()
    private let textField = UITextField()
    private let separatorView = UIView()
    
    private let counterBadgeDimensions: CGFloat = 18
    private var counterBadgeCornerRadius: CGFloat {
        counterBadgeDimensions / 2
    }
    
    init(frame: CGRect = .zero, placeholder: String = "") {
        super.init(frame: frame)
        setupAppearance()
        setupSubviews()
        setupStackViews()
        setupClearAction()
        configureTextField()
        textField.setAttributedPlaceholder(placeholder, color: .flg_blue_gray)
        textField.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showDismissButton() {
        textField.leftView = buttonStackView
    }
    
    func showMagnifierImage() {
        textField.leftView = imageStackView
    }
    
    func resignFocus() {
        textField.resignFirstResponder()
    }
    
    func addBorder(withDuration duration: CGFloat) {
        UIView.animate(withDuration: duration) {
            self.layer.borderColor = UIColor.flg_blue_gray.cgColor
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

    private func setupAppearance() {
        textField.textColor = .flg_primary_dark
        textField.tintColor = .flg_primary_dark
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor
        backgroundColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 2
        separatorView.backgroundColor = .flg_blue_gray
        textField.rightView = clearTextButton
        counterBadge.layer.cornerRadius = counterBadgeCornerRadius
        counterBadge.layer.masksToBounds = true
    }
    
    private func setupSubviews() {
        addSubview(textField)
        addSubview(separatorView)
        addSubview(showFiltersButton)
        addSubview(counterBadge)
        textField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().inset(20)
            $0.right.equalTo(separatorView.snp.left).inset(-10)
        }
        separatorView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.right.equalTo(showFiltersButton.snp.left).inset(-10)
            $0.width.equalTo(1)
        }
        showFiltersButton.snp.makeConstraints {
            $0.width.equalTo(30)
            $0.right.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        counterBadge.snp.makeConstraints {
            $0.width.height.equalTo(counterBadgeDimensions)
            $0.centerX.equalTo(showFiltersButton.snp.right)
            $0.centerY.equalTo(showFiltersButton.snp.top)
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
    
    private func setupClearAction() {
        textField.addTarget(self, action: #selector(manageClearButtonState), for: .editingChanged)
        clearTextButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
    }

    private func configureTextField() {
        textField.leftView = imageStackView
        textField.leftViewMode = .always
        textField.returnKeyType = .done
    }
    
    @objc private func manageClearButtonState(_ sender: UITextField) {
        guard let text = sender.text else { return }
        sender.rightViewMode = text.isEmpty ? .never : .always
    }
    
    @objc private func clearText() {
        textField.text?.removeAll()
        textField.sendActions(for: .editingChanged)
    }
    
}


// MARK: - UITextFieldDelegate
extension SearchFieldView: UITextFieldDelegate {
    /*
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.leftView = buttonStackView
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.leftView = imageStackView
    }
     */
}
