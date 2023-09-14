//
//  FilterAssembly.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 18.05.2023.
//

import UIKit

struct FilterAssembly: SceneAssembly {
    private let sceneOutput: FilterSceneDelegate?
    private let filterInputPassing: FilterInputPassing

    init(sceneOutput: FilterSceneDelegate?, filterInputPassing: FilterInputPassing) {
        self.sceneOutput = sceneOutput
        self.filterInputPassing = filterInputPassing
    }

    func makeScene() -> UIViewController {
        let viewModel = FilterViewModel(delegate: sceneOutput, filterInputPassing: filterInputPassing)
        let viewController = AirportFilterViewController(viewModel: viewModel)
        return viewController
    }
}
