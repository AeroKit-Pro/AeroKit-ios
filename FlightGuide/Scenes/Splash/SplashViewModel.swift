//
//  SplashPresenter.swift
//  HeyDay
//
//  Created by Eugene Kleban on 27.05.22.
//  
//

import Foundation
import FirebaseAuth

final class SplashViewModel {
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
        if FirebaseAuth.Auth.auth().currentUser == nil {
            output?.startSignUpFlow()
        } else {
            output?.startAuthorizedFlow()
        }
    }
}
