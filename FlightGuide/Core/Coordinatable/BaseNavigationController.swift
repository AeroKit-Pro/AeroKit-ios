//
//  BaseNavigationController.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 16.05.23.
//

import UIKit

final class BaseNavigationController: UINavigationController {

    var navigationBarBackgroundColor = UIColor.white
    var navigationBarTintColor = UIColor.black

    override func viewDidLoad() {
        super.viewDidLoad()
        makeNotTranslucent()
        updateNavigationBarAppearance()
        //removeNavigationBarShadow()
        addNavigationBarShadow()
        delegate = self
        interactivePopGestureRecognizer?.delegate = self
    }

    func handlePoppedViewControllerIfNeeded(_ navigationController: UINavigationController) {
        if let coordinator = navigationController.topViewController?.transitionCoordinator {
            if let fromViewController = coordinator.viewController(forKey: .from),
               !navigationController.viewControllers.contains(fromViewController) {
                // viewController is going to be popped
                if coordinator.isInteractive {
                    // if viewController is going to be poppoed via back swipe
                    // we must wait until transition is finished, to make sure that
                    // it isn't cancelled.
                    coordinator.notifyWhenInteractionChanges { [weak self] context in
                        if !context.isCancelled {
                            // handle pop event for viewController
                            self?.postNotificationThatViewControllerWasPopped()
                        }
                    }
                } else {
                    // viewController is popped after user taps back button
                    // we handle pop event immediately
                    postNotificationThatViewControllerWasPopped()
                }
            }
        }
    }

    private func postNotificationThatViewControllerWasPopped() {
        NotificationCenter.default.post(name: NSNotification.Name("didPerformPopViewController"), object: nil)
    }

    func makeNotTranslucent() {
        navigationBar.isTranslucent = false
    }

    func removeNavigationBarShadow() {
        navigationBar.scrollEdgeAppearance?.shadowColor = .clear
    }
    
    func addNavigationBarShadow() {
        let path = UIBezierPath(rect: navigationBar.bounds).cgPath
        navigationBar.layer.shadowPath = path
        navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationBar.layer.shadowOpacity = 0.2
        navigationBar.layer.shadowOffset = .zero
        navigationBar.layer.shadowRadius = 2
    }

    private func updateNavigationBarAppearance() {
        let backImage = UIImage(named: "navigationBar_backArrow")
        let appearance = UINavigationBarAppearance()
        appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = navigationBarBackgroundColor
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.tintColor = navigationBarTintColor
    }
}

extension BaseNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        handlePoppedViewControllerIfNeeded(navigationController)
    }
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
