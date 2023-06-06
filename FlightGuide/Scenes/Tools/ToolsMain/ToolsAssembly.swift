//
//  ToolsAssembly.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 25.05.23.
//

import UIKit

struct ToolsAssembly: SceneAssembly {
    private let sceneOutput: ToolsSceneOutput

    init(sceneOutput: ToolsSceneOutput) {
        self.sceneOutput = sceneOutput
    }

    func makeScene() -> UIViewController {
        let viewController = ToolsViewController()
        let viewModel = ToolsViewModel(view: viewController)
        viewController.viewModel = viewModel
        viewModel.output = sceneOutput
        return viewController
    }
}
