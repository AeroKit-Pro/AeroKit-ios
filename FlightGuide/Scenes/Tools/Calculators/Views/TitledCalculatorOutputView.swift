//
//  TitledCalculatorOutputView.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 06.07.2023.
//

import UIKit

final class TitledCalculatorOutputView: UIView {
    
    private var model: TitledCalculatorOutputModel
    
    private let stackView = UIStackView(axis: .horizontal)
    private let titleLabel = UILabel()
    private let outputLabel = UILabel()
    
    init(with model: TitledCalculatorOutputModel) {
        self.model = model
        super.init(frame: .zero)
        self.model.action = { [weak self] output in
            guard let self else { return }
            self.outputLabel.text = output
        }
        setupLayout()
        setupAppearance()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubviews(stackView)
        stackView.addArrangedSubviews(titleLabel, outputLabel)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
        outputLabel.snp.makeConstraints { _ in 
           // $0.width.equalTo(50)
        }
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

    private func setupAppearance() {
        titleLabel.text = model.title
        [titleLabel, outputLabel].forEach {
            $0.textColor = .flg_primary_dark
            $0.font = UIFont.systemFont(ofSize: 20)
            $0.textAlignment = .left
            $0.numberOfLines = 0
        }
        outputLabel.textAlignment = .right
        
        backgroundColor = .flg_light_gray
        layer.cornerRadius = 5
    }
    
}
