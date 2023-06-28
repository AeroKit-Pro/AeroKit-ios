//
//  PromptView.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 24.06.2023.
//

import UIKit

final class PromptView: UIView, Fadeable {
    
    enum PromptViewStyle {
        case small
        case medium
        case large
        
        var imageEdge: CGFloat {
            switch self {
            case .small: return 70
            case .medium: return 100
            case .large: return 150
            }
        }
    }
    
    private let stackView = UIStackView(axis: .vertical, spacing: 20)
    private let imageView = UIImageView()
    private let label = UILabel()
    private let style: PromptViewStyle
    
    init(frame: CGRect = .zero, image: UIImage?, message: String, style: PromptViewStyle) {
        self.style = style
        super.init(frame: frame)
        imageView.image = image
        label.text = message
        setupLayout()
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(stackView)
        stackView.addArrangedSubviews(imageView, label)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints {
            $0.height.equalTo(style.imageEdge)
        }
    }
    
    private func setupAppearance() {
        imageView.contentMode = .scaleAspectFit
        label.font = .systemFont(ofSize: 24)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .flg_primary_dark
        label.textAlignment = .center
        label.numberOfLines = 0
    }
    
}
