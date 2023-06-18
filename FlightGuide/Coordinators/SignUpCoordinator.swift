//
//  SignUpCoordinator.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 16.05.23.
//

import UIKit

final class SignUpCoordinator: BaseCoordinator {
    var onFinish: (() -> Void)?

    override func start() {
        openGetStarted()
    }

    func openGetStarted() {
        let scene = GetStartedViewController(nibName: nil, bundle: nil)
        scene.delegate = self
        router.root?.removeNavigationBarShadow()
        router.setRootModule(scene)
    }
}

// MARK: - GetStartedSceneOutput
extension SignUpCoordinator: GetStartedSceneOutput {
    func showLoginScene() {
        let scene = LoginAssembly(sceneOutput: self).makeScene()
        router.push(scene, animated: true)
    }

    func showSignUpScene() {
        let scene = SignUpAssembly(sceneOutput: self).makeScene()
        router.push(scene, animated: true)
    }
}

extension SignUpCoordinator: LoginSceneOutput {
    func startAuthorizedFlow() {
        onFinish?()
    }
}

extension SignUpCoordinator: SignUpSceneOutput { }
