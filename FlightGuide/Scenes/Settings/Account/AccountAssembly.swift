//
//  AccountAssembly.swift
//  HeyDay
//
//  Created by Eugene Kleban on 27.05.22.
//  
//

import UIKit

struct AccountAssembly: SceneAssembly {
    private let sceneOutput: AccountSceneOutput

    init(sceneOutput: AccountSceneOutput) {
        self.sceneOutput = sceneOutput
    }

    func makeScene() -> UIViewController {
        let viewController = AccountViewController()
        let viewModel = AccountViewModel(view: viewController)
        viewController.viewModel = viewModel
        viewModel.output = sceneOutput
        return viewController
    }
}
