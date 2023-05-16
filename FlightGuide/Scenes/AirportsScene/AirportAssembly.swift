//
//  AirportAssembly.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 16.05.23.
//

import UIKit

struct AirportAssembly: SceneAssembly {
    private let sceneOutput: AirportsSceneDelegate?

    init(sceneOutput: AirportsSceneDelegate?) {
        self.sceneOutput = sceneOutput
    }

    func makeScene() -> UIViewController {
        let viewController = AirportsViewController()
        let viewModel = AirportsViewModel(delegate: sceneOutput)
        viewController.viewModel = viewModel
        return viewController
    }
}
