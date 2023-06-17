//
//  ChecklistsTableHeaderView.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 7.06.23.
//

import UIKit

final class ChecklistsTableHeaderView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(15)
        }
    }

    func configure(title: String, underlinedText: String?) {
        if let underlinedText = underlinedText {
            let range = (title as NSString).range(of: underlinedText)
            let attributedString = NSMutableAttributedString(string: title)
            attributedString.addAttribute(.underlineStyle, value: 1, range: range)
            titleLabel.attributedText = attributedString
        } else {
            titleLabel.text = title
        }
    }
}
