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
    
    let checklistsView: ToolsItemDetailingView
    let pdfView: ToolsItemDetailingView
    let calculatorsView: ToolsItemDetailingView
    let aiChatView: ToolsItemView
    
    init(onTapPDFReader: (() -> Void)?,
         onTapChecklist: (() -> Void)?,
         onTapCalculators: (() -> Void)?,
         onTapAIChat: (() -> Void)?) {
        self.checklistsView = ToolsItemDetailingView(itemType: .checklists, onTapAction: onTapChecklist)
        self.pdfView = ToolsItemDetailingView(itemType: .pdfReader, onTapAction: onTapPDFReader)
        self.calculatorsView = ToolsItemDetailingView(itemType: .calculators, onTapAction: onTapCalculators)
        self.aiChatView = ToolsItemView(itemType: .AIChat, onTapAction: onTapAIChat)
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
            make.top.equalTo(safeAreaLayoutGuide).inset(10)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.lessThanOrEqualTo(safeAreaLayoutGuide)
        }
        
        stackView.addArrangedSubview(checklistsView)
        stackView.addArrangedSubview(pdfView)
        stackView.addArrangedSubview(calculatorsView)
        stackView.addArrangedSubview(aiChatView)
    }
    
    private func setupUI() {
        backgroundColor = .white
    }
}
