//
//  AIChatAssembly.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 11.06.2023.
//

import UIKit

struct AIChatAssembly: SceneAssembly {
    func makeScene() -> UIViewController {
        let viewController = AIChatViewController()
        let viewModel = AIChatViewModel()
        viewController.viewModel = viewModel
        return viewController
    }
}
