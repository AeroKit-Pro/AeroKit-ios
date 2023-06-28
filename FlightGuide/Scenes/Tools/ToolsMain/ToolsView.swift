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
    var onTapAIChat: (() -> Void)?

    let checklistsView: ToolsItemView
    let pdfView: ToolsItemView

    init(onTapPDFReader: (() -> Void)?,
         onTapChecklist: (() -> Void)?) {
        self.checklistsView = ToolsItemView(itemType: .checklists, onTapAction: onTapChecklist)
        self.pdfView = ToolsItemView(itemType: .pdfReader, onTapAction: onTapPDFReader)

         onTapChecklist: (() -> Void)?,
         onTapAIChat: (() -> Void)? {
        self.onTapPDFReader = onTapPDFReader
        self.onTapChecklist = onTapChecklist
        self.onTapAIChat = onTapAIChat
        super.init(frame: .zero)
        setupLayout()
        setupUI()
         }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(10)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.lessThanOrEqualTo(safeAreaLayoutGuide)
        }

        stackView.addArrangedSubview(checklistsView)
        stackView.addArrangedSubview(pdfView)
        stackView.addArrangedSubview(ToolsItemDetailingView(itemType: .checklists, onTapAction: onTapChecklist))
        stackView.addArrangedSubview(ToolsItemDetailingView(itemType: .pdfReader, onTapAction: onTapPDFReader))
        stackView.addArrangedSubview(ToolsItemView(itemType: .AIChat, onTapAction: onTapAIChat))
    }

    private func setupUI() {
        backgroundColor = .white
    }
}
