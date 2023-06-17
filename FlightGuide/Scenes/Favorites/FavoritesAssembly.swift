//
//  FavoritesAssembly.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 25.05.2023.
//

import UIKit

struct FavoritesAssembly: SceneAssembly {
    private let sceneOutput: FavoritesSceneDelegate?

    init(sceneOutput: FavoritesSceneDelegate?) {
        self.sceneOutput = sceneOutput
    }

    func makeScene() -> UIViewController {
        let viewModel = FavoritesViewModel(delegate: sceneOutput,
                                           notificationsCenter: DIContainer.default.notificationService)
        let viewController = FavoritesViewController(viewModel: viewModel)
        return viewController
    }
}
