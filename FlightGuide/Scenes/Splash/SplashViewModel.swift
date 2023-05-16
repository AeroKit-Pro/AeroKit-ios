//
//  SplashPresenter.swift
//  HeyDay
//
//  Created by Eugene Kleban on 27.05.22.
//  
//

import Foundation

final class SplashViewModel {

    private var shouldShowAuthorizationFlow = false
    // MARK: Properties
    weak var view: SplashViewInterface!
    weak var output: SplashSceneOutput?

    // MARK: Methods
    init(view: SplashViewInterface) {
        self.view = view
    }
}

// MARK: SplashPresenterInterface
extension SplashViewModel: SplashViewModelInterface {
    func viewDidLoad() {
        displayDesiredFlow()
    }

    private func displayDesiredFlow() {
        if shouldShowAuthorizationFlow {
            output?.startSignUpFlow()
        } else {
            output?.startAuthorizedFlow()
        }
    }
}
