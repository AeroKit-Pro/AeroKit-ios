//
//  ToolsViewModel.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 25.05.23.
//

import Foundation

final class ToolsViewModel {

    // MARK: Properties
    weak var view: ToolsViewInterface!
    weak var output: ToolsSceneOutput?

    // MARK: Methods
    init(view: ToolsViewInterface) {
        self.view = view
    }
}

// MARK: ToolsPresenterInterface
extension ToolsViewModel: ToolsViewModelInterface {
    func viewDidLoad() {

    }
    func onTapChecklists() {
        output?.showChecklists()
    }

    func onTapPdfReader() {
        output?.showPDFReader()
    }
}
