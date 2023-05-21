//
//  AirportFilterSearchItemsView.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 8.05.23.
//

import UIKit

final class AirportFilterSearchItemsView<ItemType: CaseIterable & ModelTitlable & Indexable>: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Items of search"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .semibold) // TODO: fonts
        return label
    }()

    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.selectedSegmentTintColor = .flg_primary_dark
        let normalAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
                                NSAttributedString.Key.foregroundColor: UIColor.black]
        segmentedControl.setTitleTextAttributes(normalAttributes, for: .normal)
        let selectedAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(selectedAttributes, for:.selected)
        return segmentedControl
    }()
    
    let items: [ItemType]
    
    var selectedItem: ItemType {
        set { segmentedControl.selectedSegmentIndex = newValue.index }
        get { items[segmentedControl.selectedSegmentIndex] }
    }
    
    var selectedSegmentIndex: Int {
        segmentedControl.selectedSegmentIndex
    }

    override init(frame: CGRect) {
        items = Array(ItemType.allCases)
        super.init(frame: frame)
        setupLayout()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubviews(titleLabel, segmentedControl)

        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(10)
        }

        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(46)
        }
    }

    private func setupUI() {
        backgroundColor = .flg_light_dark_white
        layer.cornerRadius = 16

        items.enumerated().forEach { index, item in
            segmentedControl.insertSegment(withTitle: item.title, at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
    }
}
