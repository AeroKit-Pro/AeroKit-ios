//
//  ToolsCoordinator.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 25.05.23.
//

import UIKit
import CoreServices
import PDFKit


final class ToolsCoordinator: BaseCoordinator {

    //MARK: - Lifecycle
    override func start() {
        openAirports()
    }

    func openAirports() {
        let scene = ToolsAssembly(sceneOutput: self).makeScene()
        startingViewController = scene
        router.setRootModule(scene, hideBar: true)
    }
}

// MARK: - ChannelListSceneDelegate
extension ToolsCoordinator: ToolsSceneOutput, UIDocumentPickerDelegate {
    func showPDFReader() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        router.present(documentPicker, animated: true)
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileURL = urls.first else { return }
        let reader = PDFReaderViewController(fileURL: fileURL)
        router.push(reader, animated: true)
    }
}
