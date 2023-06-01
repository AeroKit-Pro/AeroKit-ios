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
                             onTapChecklist: { [weak self] in self?.viewModel?.onTapChecklists() })
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
        viewModel?.viewDidLoad()

        toolsView.onTapChecklist = {
        }
    }
}

// MARK: ToolsView Protocol
extension ToolsViewController: ToolsViewInterface {
}
