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

struct AirportsFilterSelectionItem<ItemType: CaseIterable & ModelTitlable & Indexable> {
    let type: ItemType
    var isSelected: Bool
}

final class AirportsFilterSelectionView<ItemType: CaseIterable & ModelTitlable & Indexable>: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private let scrollView = UIScrollView()
    private let stackView = UIStackView(axis: .horizontal, spacing: 24)
    var items = [AirportsFilterSelectionItem<ItemType>]()
    
    var selectedItems: [ItemType] {
        set { newValue.forEach { setSelectedState(at: $0.index) } }
        get { getSelectedItems() }
    }

    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupLayout()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSelectedState(at index: Int) {
        guard let item = stackView.arrangedSubviews[index] as? AirportsFilterSelectableControl<ItemType> else { return }
        item.isItemSelected = true
        
    }
    
    private func getSelectedItems() -> [ItemType] {
        stackView.arrangedSubviews
            .compactMap { $0 as? AirportsFilterSelectableControl<ItemType> }
            .filter { $0.isItemSelected }
            .map { $0.item }
    }

    private func setupLayout() {
        addSubviews(titleLabel, scrollView)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(10)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.leading.trailing.equalToSuperview()
        }

        scrollView.addSubviews(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()//.inset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(scrollView)
//            make.height.equalTo(55)
        }
    }

    private func setupUI() {
        backgroundColor = .flg_light_dark_white
        layer.cornerRadius = 16
        scrollView.showsHorizontalScrollIndicator = false

        self.items = ItemType.allCases.map { AirportsFilterSelectionItem(type: $0, isSelected: false) }
        
        ItemType.allCases.forEach {
            stackView.addArrangedSubview(AirportsFilterSelectableControl<ItemType>(item: $0))
        }
    }
}

final class AirportsFilterSelectableControl<ItemType: CaseIterable & ModelTitlable>: UIControl {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .regular) // TODO: fonts
        return label
    }()
    
    let item: ItemType

    var isItemSelected: Bool = false {
        didSet {
            updateImageState()
            sendActions(for: .valueChanged)
        }
    }

    init(item: ItemType, isSelected: Bool = false) {
        self.item = item
        super.init(frame: .zero)
        titleLabel.text = item.title
        isItemSelected = isSelected
        setupLayout()
        updateImageState()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubviews(imageView, titleLabel)

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
