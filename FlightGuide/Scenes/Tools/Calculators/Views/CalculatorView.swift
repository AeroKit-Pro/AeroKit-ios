//
//  CalculatorView.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 06.07.2023.
//

import UIKit

final class CalculatorView: UIView {
    
    private let model: Calculator
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let separator = UIView()
    private let stackView = UIStackView(axis: .vertical, spacing: 5)
    private let inputFields: [TitledCalculatorInputFieldView]
    private let outputs: [TitledCalculatorOutputView]
    
    init(with model: Calculator) {
        self.model = model
        self.inputFields = model.inputs.map { TitledCalculatorInputFieldView(with: $0) }
        self.outputs = model.outputs.map { TitledCalculatorOutputView(with: $0) }
        super.init(frame: .zero)
        setupLayout()
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func becomeResponder() {
        inputFields.first?.becomeReponder()
    }
    
    private func setupLayout() {
        containerView.addSubviews(titleLabel, separator, stackView)
        addSubview(containerView)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.left.right.equalToSuperview().inset(10)
        }
        separator.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).inset(-10)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }
        stackView.snp.makeConstraints {
            $0.top.equalTo(separator).inset(10)
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(10)
        }
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.right.equalToSuperview().inset(20)
        }
        
        inputFields.forEach { stackView.addArrangedSubview($0) }
        outputs.forEach { stackView.addArrangedSubview($0) }
    }
    
    private func setupAppearance() {
        backgroundColor = .flg_light_dark_white
        titleLabel.text = model.title
        titleLabel.textColor = .flg_primary_dark
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        
        separator.backgroundColor = .flg_secondary_gray
    }
    
}
