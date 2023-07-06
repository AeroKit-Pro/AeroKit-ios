//
//  SettingsAssembly.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 2.07.23.
//

import UIKit

struct SettingsAssembly: SceneAssembly {
    private let sceneOutput: SettingsSceneOutput

    init(sceneOutput: SettingsSceneOutput) {
        self.sceneOutput = sceneOutput
    }

    func makeScene() -> UIViewController {
        let viewController = SettingsViewController()
        let viewModel = SettingsViewModel(view: viewController)
        viewController.viewModel = viewModel
        viewModel.output = sceneOutput
        return viewController
    }
}
