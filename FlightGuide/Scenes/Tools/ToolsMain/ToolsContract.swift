//
//  ToolsContract.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 25.05.23.
//

import Foundation

protocol ToolsViewInterface: AnyObject {
    func showRecentPdfURLs(urls: [URL])
    func showRecentChecklists(checklists: [ChecklistGroupStorageModel])
}

protocol ToolsViewModelInterface: AnyObject {
    func viewWillAppear()
    func onTapChecklists()
    func onTapPdfReader()
    func onTapPdfURL(_ url: URL)
    func onTapRecentChecklist(model: ChecklistGroupStorageModel)
}

protocol ToolsSceneOutput: AnyObject {
    func showPDFReader()
    func showChecklists()
    func showPDFReader(url: URL)
    func showChecklistsInspection(items: [ChecklistWithItemsModel])
}
