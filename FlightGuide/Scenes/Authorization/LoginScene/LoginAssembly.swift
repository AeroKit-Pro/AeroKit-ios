//
//  LoginAssembly.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 17.06.23.
//  
//

import UIKit

struct LoginAssembly: SceneAssembly {
    private let sceneOutput: LoginSceneOutput

    init(sceneOutput: LoginSceneOutput) {
        self.sceneOutput = sceneOutput
    }

    func makeScene() -> UIViewController {
        let viewController = LoginViewController()
        let viewModel = LoginViewModel(view: viewController)
        viewController.viewModel = viewModel
        viewModel.output = sceneOutput
        return viewController
    }
}
