//
//  SignUpViewModel.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 17.06.23.
//
//

import Foundation

final class SignUpViewModel {

    private var shouldShowAuthorizationFlow = true
    // MARK: Properties
    weak var view: SignUpViewInterface!
    weak var output: SignUpSceneOutput?

    // MARK: Methods
    init(view: SignUpViewInterface) {
        self.view = view
    }

    private func validatePassword(text: String?) -> Bool {
        guard let text = text else { return false }
        return text.count >= 6
    }

    private func validateName(text: String?) -> Bool {
        guard let text = text else { return false }
        return text.count >= 3
    }

    private func validateEmail(text: String?) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: text)
    }
}

// MARK: SignUpViewModelInterface
extension SignUpViewModel: SignUpViewModelInterface {
    func viewDidLoad() {
    }

    
    func onTapSignUp(email: String?, name: String?, password: String?) {
        guard validateName(text: name) else {
            view?.displayNameErrorState(isErrorState: true, error: "Name must have at least 3 characters")
            return
        }

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
