//
//  ToolsContract.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 25.05.23.
//

import Foundation

protocol ToolsViewInterface: AnyObject {
}

protocol ToolsViewModelInterface: AnyObject {
    func viewDidLoad()
    func onTapChecklists()
    func onTapPdfReader()
    func onTapAIChat()
}

protocol ToolsSceneOutput: AnyObject {
    func showPDFReader()
    func showChecklists()
    func showAIChat()
}
