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
    private let pdfStorageService = PDFStorageService()
    //MARK: - Lifecycle
    override func start() {
        openTools()
    }

    func openTools() {
        let scene = ToolsAssembly(sceneOutput: self).makeScene()
        startingViewController = scene
        router.setRootModule(scene, hideBar: true)
    }
}

// MARK: - ToolsSceneOutput
extension ToolsCoordinator: ToolsSceneOutput, UIDocumentPickerDelegate {
    func showPDFReader() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        router.present(documentPicker, animated: true)
    }

    func showPDFReader(url: URL) {
        let reader = PDFReaderViewController(fileURL: url)
        router.push(reader, animated: true)
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileURL = urls.first else { return }
        pdfStorageService.storeData(with: fileURL) { [weak self] newURL in
            guard let newURL = newURL else { return }
            DispatchQueue.main.async {
                self?.showPDFReader(url: newURL)
            }
        }
    }

    func showChecklists() {
        let scene = ChecklistsAssembly(sceneOutput: self).makeScene()
        router.push(scene, animated: true)
    }
}

// MARK: - ChecklistsSceneDelegate
extension ToolsCoordinator: ChecklistsSceneDelegate {
    func showSelectPlaneCompany() {
        let scene = SelectCompanyViewController(nibName: nil, bundle: nil)
        scene.delegate = self
        router.push(scene, animated: true)
    }

    func showMyGroupChecklist(items: [ChecklistWithItemsModel]) {
        let scene = ChecklistGroupViewController(nibName: nil, bundle: nil)
        scene.items = items
        scene.delegate = self
        router.push(scene, animated: true)
    }
}

// MARK: - SelectCompanySceneDelegate
extension ToolsCoordinator: SelectCompanySceneDelegate {
    func showPlaneSelection(model: CompanyWithPlanesModel) {
        let scene = SelectPlaneViewController(nibName: nil, bundle: nil)
        scene.items = model.planes
        scene.companyName = model.name
        scene.delegate = self
        router.push(scene, animated: true)
    }
}

// MARK: - SelectPlaneSceneDelegate
extension ToolsCoordinator: SelectPlaneSceneDelegate {
    func showChecklistSelection(model: PlaneWithChecklistsModel, companyNameWithModel: String) {
        let scene = ChecklistsSelectionViewController(nibName: nil, bundle: nil)
        scene.companyNameWithModel = companyNameWithModel
        scene.items = model.checklists
        scene.delegate = self
        router.push(scene, animated: true)
    }
}

// MARK: - ChecklistsSelectionSceneDelegate
extension ToolsCoordinator: ChecklistsSelectionSceneDelegate {
    func showChecklistsInspection(items: [ChecklistWithItemsModel]) {
        let scene = ChecklistInspectionViewController(nibName: nil, bundle: nil)
        scene.items = items
        scene.onFinish = { [weak self] in
            guard let self = self else { return }
            if !self.router.pop(to: ChecklistsViewController.self, animated: true) {
                self.router.popToRootModule(animated: true)
            }
        }
        router.push(scene, animated: true)

    }
}

// MARK: - ChecklistGroupSceneDelegate
extension ToolsCoordinator: ChecklistGroupSceneDelegate {

}
