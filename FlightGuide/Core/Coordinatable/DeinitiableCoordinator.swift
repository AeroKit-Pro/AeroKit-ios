//
//  DeinitiableCoordinator.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 16.05.23.
//

import UIKit

protocol DeinitableCoordinator: AnyObject {
//    var notificationCenter: NotificationCenter { get }
    var router: Router { get }
    var startingViewController: UIViewController? { get set }
    func didFinishScene()
}

extension DeinitableCoordinator {
    func storeStartingViewController() {
        startingViewController = router.root?.viewControllers.last
    }

    func removedObserverForPoppedViewController() {
        NotificationCenter.default.removeObserver(self)
    }

    func handlePoppedViewControllerEvent() {
        if let startingViewController = startingViewController,
           let root = router.root,
           !root.viewControllers.contains(startingViewController) {
            self.startingViewController = nil
            didFinishScene()
        }
    }

    func setNavigationControllerPopObserver(selector: Selector) {
        // TODO: Move to DI
        NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name("didPerformPopViewController"), object: nil)
    }
}
