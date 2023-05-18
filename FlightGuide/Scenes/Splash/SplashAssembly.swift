//
//  SplashConfigurator.swift
//  HeyDay
//
//  Created by Eugene Kleban on 27.05.22.
//  
//

import UIKit

protocol SceneAssembly {
    func makeScene() -> UIViewController
}

struct SplashAssembly: SceneAssembly {
    private let sceneOutput: SplashSceneOutput

    init(sceneOutput: SplashSceneOutput) {
        self.sceneOutput = sceneOutput
    }

    func makeScene() -> UIViewController {
        let viewController = SplashViewController()
        let presenter = SplashViewModel(view: viewController)
        viewController.presenter = presenter
        presenter.output = sceneOutput
        return viewController
    }
}
