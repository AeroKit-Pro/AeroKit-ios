//
//  SignUpAssembly.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 17.06.23.
//  
//

import UIKit

struct SignUpAssembly: SceneAssembly {
    private let sceneOutput: SignUpSceneOutput

    init(sceneOutput: SignUpSceneOutput) {
        self.sceneOutput = sceneOutput
    }

    func makeScene() -> UIViewController {
        let viewController = SignUpViewController()
        let viewModel = SignUpViewModel(view: viewController)
        viewController.viewModel = viewModel
        viewModel.output = sceneOutput
        return viewController
    }
}
