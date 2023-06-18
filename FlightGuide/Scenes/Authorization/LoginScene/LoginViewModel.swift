//
//  LoginViewModel.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 17.06.23.
//
//

import Foundation

final class LoginViewModel {

    private var shouldShowAuthorizationFlow = true
    // MARK: Properties
    weak var view: LoginViewInterface!
    weak var output: LoginSceneOutput?

    // MARK: Methods
    init(view: LoginViewInterface) {
        self.view = view
    }


    private func validatePassword(text: String?) -> Bool {
        guard let text = text else { return false }
        return text.count >= 6
    }

    private func validateEmail(text: String?) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: text)
    }

}

// MARK: LoginViewModelInterface
extension LoginViewModel: LoginViewModelInterface {
    func viewDidLoad() {
    }

    func onTapSignIn(email: String?, password: String?) {
        guard validateEmail(text: email) else {
            view?.displayEmailErrorState(isErrorState: true, error: "Not valid email")
            return
        }
        guard validatePassword(text: password) else {
            view?.displayPasswordErrorState(isErrorState: true, error: "Password must have at least 6 characters")
            return
        }
        output?.startAuthorizedFlow()
    }
}
