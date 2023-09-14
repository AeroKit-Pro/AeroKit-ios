//
//  ChecklistsEmptyView.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 8.06.23.
//

import UIKit

final class ChecklistsEmptyView: UIView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "checklists_emptyLogo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let emptyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Here will be your checklits"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .thin)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 89, height: 79))
        }

        addSubview(emptyTitleLabel)
        emptyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(50)
        }
    }
}
