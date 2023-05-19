//
//  CounterBadge.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 19.05.2023.
//

import UIKit

final class CounterBadge: UILabel {

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAppearance() {
        backgroundColor = .white
        textColor = .flg_primary_dark
        font = .systemFont(ofSize: 10)
        textAlignment = .center
        layer.borderColor = UIColor.flg_primary_dark.cgColor
        layer.borderWidth = 1
        adjustsFontSizeToFitWidth = true
    }

}
