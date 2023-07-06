//
//  SettingsCoordinator.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 2.07.23.
//

import Foundation

final class SettingsCoordinator: BaseCoordinator {
    var onTapLogout: (() -> Void)?

    // MARK: - Lifecycle
    override func start() {
        openSettings()
    }

    func openSettings() {
        let scene = SettingsAssembly(sceneOutput: self).makeScene()
        startingViewController = scene
        router.setRootModule(scene, hideBar: true)
    }
}

// MARK: - SettingsSceneOutput
extension SettingsCoordinator: SettingsSceneOutput {
    func showAccountScene() {
        let scene = AccountAssembly(sceneOutput: self).makeScene()
        router.push(scene, animated: true)
    }

    func showAboutUsScene() {
        let scene = AboutViewController(nibName: nil, bundle: nil)
        router.push(scene, animated: true)
    }

    func didTapLogout() {
        onTapLogout?()
    }
}

// MARK: - AccountSceneOutput
extension SettingsCoordinator: AccountSceneOutput {

}
