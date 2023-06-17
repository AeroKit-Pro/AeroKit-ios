//
//  AirportAssembly.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 16.05.23.
//

import UIKit

struct AirportAssembly: SceneAssembly {
    private let sceneOutput: AirportsSceneDelegate?
    private let filterInputPassing: FilterInputPassing

    init(sceneOutput: AirportsSceneDelegate?, filterInputPassing: FilterInputPassing) {
        self.sceneOutput = sceneOutput
        self.filterInputPassing = filterInputPassing
    }

    func makeScene() -> UIViewController {
        let viewModel = AirportsViewModel(delegate: sceneOutput,
                                          filterInputPassing: filterInputPassing,
                                          notificationCenter: DIContainer.default.notificationService)
        let viewController = AirportsViewController(viewModel: viewModel)
        return viewController
    }
}
