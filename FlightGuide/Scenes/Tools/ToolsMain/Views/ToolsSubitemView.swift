//
//  ToolsSubitemView.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 15.06.23.
//

import UIKit

final class ToolsSubitemView: UIView {
    enum ItemType {
        case checklist(name: String, isFullModel: Bool, onTap: (() -> Void)?)
        case pdfFile(name: String, onTap: (() -> Void)?)

        var name: String {
            switch self {
            case .checklist(let name, _, _),
                 .pdfFile(let name, _):
                return name
            }
        }

        var buttonImage: UIImage? {
            switch self {
            case .checklist(_, let isFullModel, _):
                return UIImage(named: isFullModel ? "checklists_plane" : "checklists_list")
            case .pdfFile:
                return UIImage(named: "checklists_document")
            }
        }
    }

    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hex(0xD9D9D9)
        view.layer.cornerRadius = 10
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let itemType: ItemType

    init(itemType: ItemType) {
        self.itemType = itemType
        super.init(frame: .zero)
        setupLayout()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubviews(contentView)
        contentView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
        contentView.addSubviews(imageView, titleLabel)

        imageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(5)
            make.size.equalTo(20)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(5)
            make.trailing.equalToSuperview().inset(5)
            make.centerY.equalTo(imageView)
        }
    }

    private func setupUI() {
        titleLabel.text = itemType.name
        imageView.image = itemType.buttonImage

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapContentView))
        contentView.addGestureRecognizer(tapGesture)
    }

    @objc
    private func didTapContentView() {
        switch itemType {
        case .checklist(_, _, let onTap):
            onTap?()
        case .pdfFile(_, let onTap):
            onTap?()
        }
    }
}
