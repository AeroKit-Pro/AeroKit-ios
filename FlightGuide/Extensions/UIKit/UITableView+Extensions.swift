//
//  UITableView+Extensions.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 5.06.23.
//

import UIKit

extension UITableView {
    func setSystemLayoutSizeFittingHeaderView(_ headerView: UIView) {
        let targetSize = CGSize(width: bounds.size.width, height: UIView.layoutFittingCompressedSize.height)
        let size = headerView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        )
        headerView.frame = CGRect(origin: .zero, size: size)
        headerView.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        headerView.layoutIfNeeded()
        self.tableHeaderView = headerView
    }
}
