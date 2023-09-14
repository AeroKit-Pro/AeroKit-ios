//
//  ChecklistsAssembly.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 6.06.23.
//

import UIKit

struct ChecklistsAssembly: SceneAssembly {
    private let sceneOutput: ChecklistsSceneDelegate

    init(sceneOutput: ChecklistsSceneDelegate) {
        self.sceneOutput = sceneOutput
    }

    func makeScene() -> UIViewController {
        let viewController = ChecklistsViewController()
        let viewModel = ChecklistsViewModel()
        viewModel.view = viewController
        viewController.viewModel = viewModel
        viewModel.output = sceneOutput
        return viewController
    }
}
