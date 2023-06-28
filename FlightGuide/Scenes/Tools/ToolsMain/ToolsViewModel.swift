//
//  ToolsViewModel.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 25.05.23.
//

import Foundation

final class ToolsViewModel {
    @UserDataStorage(key: UserDefaultsKey.savedChecklists) private var savedChecklists: [ChecklistGroupStorageModel]?

    private let pdfStorageService = PDFStorageService()
    private let maxRecentChecklistsCount = 2

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
    func viewWillAppear() {
        pdfStorageService.retrieveAllURLs { [weak self] urls in
            DispatchQueue.main.async {
                self?.view?.showRecentPdfURLs(urls: urls)
            }
        }

        if let savedChecklists = savedChecklists {
            view?.showRecentChecklists(checklists: Array(savedChecklists.suffix(maxRecentChecklistsCount)))
        }
    }

    func onTapChecklists() {
        output?.showChecklists()
    }

    func onTapPdfReader() {
        output?.showPDFReader()
    }

    func onTapPdfURL(_ url: URL) {
        output?.showPDFReader(url: url)
    }

    func onTapRecentChecklist(model: ChecklistGroupStorageModel) {
        output?.showChecklistsInspection(items: model.checklists)
    }
    func onTapAIChat() {
        output?.showAIChat()
    }
}
