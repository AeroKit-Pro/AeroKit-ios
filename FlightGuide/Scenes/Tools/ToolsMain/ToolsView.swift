//
//  ToolsView.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 25.05.23.
//

import UIKit

final class ToolsView: UIView {
    private let stackView = UIStackView(axis: .vertical, spacing: 16)

    var onTapPDFReader: (() -> Void)?
    var onTapChecklist: (() -> Void)?

    init(onTapPDFReader: (() -> Void)?,
         onTapChecklist: (() -> Void)?) {
        self.onTapPDFReader = onTapPDFReader
        self.onTapChecklist = onTapChecklist
        super.init(frame: .zero)
        setupLayout()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.lessThanOrEqualTo(safeAreaLayoutGuide)
        }

        stackView.addArrangedSubview(ToolsItemView(itemType: .checklists, onTapAction: onTapChecklist))
        stackView.addArrangedSubview(ToolsItemView(itemType: .pdfReader, onTapAction: onTapPDFReader))
    }

    private func setupUI() {
        backgroundColor = .white
    }
}
