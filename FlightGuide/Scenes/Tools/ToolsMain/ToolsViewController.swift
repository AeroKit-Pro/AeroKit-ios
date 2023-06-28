//
//  ToolsViewController.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 25.05.23.
//

import UIKit

final class ToolsViewController: UIViewController {

    // MARK: Properties
    private lazy var toolsView: ToolsView = {
        let view = ToolsView(onTapPDFReader: { [weak self] in self?.viewModel?.onTapPdfReader() },
                             onTapChecklist: { [weak self] in self?.viewModel?.onTapChecklists() },
                             onTapAIChat: { [weak self] in self?.viewModel?.onTapAIChat() })
        return view
    }()

    var viewModel: ToolsViewModelInterface?

    override func loadView() {
        view = toolsView
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Tools"
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.viewWillAppear()
    }
}

// MARK: ToolsView Protocol
extension ToolsViewController: ToolsViewInterface {

    func showRecentPdfURLs(urls: [URL]) {

        let items = urls.map { item in
            ToolsSubitemView(itemType: .pdfFile(name: item.lastPathComponent,
                                                onTap: { [weak self] in self?.viewModel?.onTapPdfURL(item) }))
        }
        toolsView.pdfView.updateSubitems(items: items)
    }

    func showRecentChecklists(checklists: [ChecklistGroupStorageModel]) {
        let items = checklists.map { item in
            ToolsSubitemView(itemType: .checklist(name: item.name,
                                                  isFullModel: item.isFullChecklistModel,
                                                  onTap: { [weak self] in self?.viewModel?.onTapRecentChecklist(model: item) }))
        }
        toolsView.checklistsView.updateSubitems(items: items)
    }
}
