//
//  AppCoordinator.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 16.05.23.
//

import UIKit

protocol ApplicationCoordinatorInterface: Coordinatable { }

/// Main coordinator of application
final class AppCoordinator: BaseCoordinator {
    // MARK: - Properties
    private weak var window: UIWindow?

    // MARK: - Initialization
    init(window: UIWindow) {
        let navigationController = BaseNavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        super.init(router: Router(rootController: navigationController))
    }

    // MARK: - Lifecycle
    override func start() {
        router.setRootModule(SplashAssembly(sceneOutput: self).makeScene())
    }

    @objc
    private func failedToRefreshAccessToken() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            if let tabCoordinator = self?.children.compactMap({ $0 as? TabCoordinator }).first {
                self?.didLogoutUser(tabCoordinator)
            }
        }
    }
}

// MARK: - ApplicationCoordinatorProtocol
extension AppCoordinator: ApplicationCoordinatorInterface {
}

// MARK: - TabCoordinatorDelegate
extension AppCoordinator: TabCoordinatorDelegate {
    func didLogoutUser(_ coordinator: TabCoordinator) {
        DispatchQueue.main.async {
            self.startSignUpFlow()
            self.remove(coordinator)
        }
    }
}

// MARK: - SplashSceneOutput
extension AppCoordinator: SplashSceneOutput {
    func startSignUpFlow() {
        let signUpCoordinator = SignUpCoordinator(router: router)
        signUpCoordinator.onFinish = { [weak self, weak signUpCoordinator] in
            guard let self = self, let signUpCoordinator = signUpCoordinator else { return }
            DispatchQueue.main.async {
                self.startAuthorizedFlow()
                self.remove(signUpCoordinator)
            }
        }
        add(signUpCoordinator)
        signUpCoordinator.start()
    }

    func startAuthorizedFlow() {
        guard let navigationController = router.root else { return }
        let tabCoordinator = TabCoordinator(
            navigationController: navigationController,
            delegate: self
        )
        add(tabCoordinator)
        tabCoordinator.start()
    }
}
