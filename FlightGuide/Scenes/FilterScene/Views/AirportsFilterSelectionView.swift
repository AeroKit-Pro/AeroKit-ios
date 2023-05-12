//
//  AirportsFilterSelectionView.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 6.05.23.
//

import UIKit

protocol ModelTitlable {
    var title: String { get }
}

struct AirportsFilterSelectionItem<ItemType: CaseIterable & ModelTitlable> {
    let type: ItemType
    var isSelected: Bool
}

final class AirportsFilterSelectionView<ItemType: CaseIterable & ModelTitlable>: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private let scrollView = UIScrollView()
    private let stackView = UIStackView(axis: .horizontal, spacing: 24)
    var items = [AirportsFilterSelectionItem<ItemType>]()

    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupLayout()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubviewsWithoutAutoresizingMask(titleLabel, scrollView)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(10)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.leading.trailing.equalToSuperview()
        }

        scrollView.addSubviewsWithoutAutoresizingMask(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()//.inset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(scrollView)
//            make.height.equalTo(55)
        }
    }

    private func setupUI() {
        backgroundColor = UIColor.hex(0xF8F8F8)
        layer.cornerRadius = 16
        scrollView.showsHorizontalScrollIndicator = false

        ItemType.allCases.enumerated().forEach {
            stackView.addArrangedSubview(AirportsFilterSelectableControl(title: $0.element.title))
        }
    }
}

final class AirportsFilterSelectableControl: UIControl {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular) // TODO: fonts
        return label
    }()

    private var isItemSelected: Bool = false {
        didSet {
            updateImageState()
            sendActions(for: .valueChanged)
        }
    }

    init(title: String, isSelected: Bool = false) {
        super.init(frame: .zero)
        titleLabel.text = title
        isItemSelected = isSelected
        setupLayout()
        updateImageState()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubviewsWithoutAutoresizingMask(imageView, titleLabel)

        snp.makeConstraints { make in
            make.height.equalTo(55)
        }
        imageView.snp.makeConstraints { make in
            make.size.equalTo(25)
            make.leading.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(5)
            make.trailing.centerY.equalToSuperview()
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(controlTapped(_:)))
        addGestureRecognizer(tapGesture)
    }

    private func updateImageState() {
        imageView.image = UIImage(named: isItemSelected ? "filterCheckmark_selected" : "filterCheckmark_notSelected")
    }

    @objc
    private func controlTapped(_ sender: UITapGestureRecognizer) {
        isItemSelected.toggle()
    }
}