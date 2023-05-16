//
//  SignUpCoordinator.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 16.05.23.
//

import UIKit

final class SignUpCoordinator: BaseCoordinator {
    override func start() {
        openGetStarted()
    }

    func openGetStarted() {
        let scene = UIViewController()
        router.root?.removeNavigationBarShadow()
        router.setRootModule(scene)
    }
}
