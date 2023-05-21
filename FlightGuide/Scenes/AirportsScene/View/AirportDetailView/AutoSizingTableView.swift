//
//  AutoSizingTableView.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 20.05.2023.
//

import UIKit

final class AutoSizingTableView: UITableView {

    // MARK: - Initialize
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    private func initialize() {
        self.alwaysBounceHorizontal = false
        self.alwaysBounceVertical = false
    }

    // MARK: - UITableView
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
