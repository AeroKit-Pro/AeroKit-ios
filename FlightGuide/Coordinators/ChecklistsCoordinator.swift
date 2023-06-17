//
//  ChecklistsCoordinator.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 6.06.23.
//

import UIKit
import CoreServices
import PDFKit

final class ChecklistsCoordinator: BaseCoordinator {

    //MARK: - Lifecycle
    override func start() {
        openSelectCompany()
    }

    func openSelectCompany() {
//        let scene = SelectCompanyViewController(sceneOutput: self).makeScene()
//        startingViewController = scene
//        router.setRootModule(scene, hideBar: true)
    }
}

//// MARK: - ChannelListSceneDelegate
//extension ChecklistsCoordinator: ToolsSceneOutput, UIDocumentPickerDelegate {
//    func showPDFReader() {
//        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
//        documentPicker.delegate = self
//        documentPicker.allowsMultipleSelection = false
//        router.present(documentPicker, animated: true)
//    }
//
//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//        guard let fileURL = urls.first else { return }
//        let reader = PDFReaderViewController(fileURL: fileURL)
//        router.push(reader, animated: true)
//    }
//
//    func showChecklists() {
//        let scene = ChecklistsViewController(nibName: nil, bundle: nil)
//        router.push(scene, animated: true)
//    }
//}
//
//// MARK: - ChecklistsSceneDelegate
//extension ChecklistsCoordinator: ChecklistsSceneDelegate {
//    func showSelectPlaneCompany() {
//        let scene = SelectPlaneViewController(nibName: nil, bundle: nil)
////        scene.delegate = self
//        router.push(scene, animated: true)
//    }
//}
