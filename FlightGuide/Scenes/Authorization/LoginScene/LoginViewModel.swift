//
//  LoginViewModel.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 17.06.23.
//
//

import Foundation
import Firebase
import GoogleSignIn

final class LoginViewModel {

    private var shouldShowAuthorizationFlow = true
    private let appleAuthService = AppleAuthorizationService()
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
        guard let email = email,
              validateEmail(text: email) else {
            view?.displayEmailErrorState(isErrorState: true, error: "Not valid email")
            return
        }
        guard let password = password,
              validatePassword(text: password) else {
            view?.displayPasswordErrorState(isErrorState: true, error: "Password must have at least 6 characters")
            return
        }
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.view?.displayLoginErrorAlert(error: error)
                return
            }

            self?.output?.startAuthorizedFlow()
        }
    }

    func onTapSignInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        view.displaySignInWithGoogle()
    }

    func onSignInWithGoogleResult(result: GIDSignInResult?, error: Error?) {
        if let error = error {
            view.displayLoginErrorAlert(error: error)
            return
        }
        guard let user = result?.user,
              let idToken = user.idToken?.tokenString else {
            return
        }

        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: user.accessToken.tokenString)
        view.displayLoader()
        Auth.auth().signIn(with: credential) { [weak self] result, error in
            self?.view.hideLoader()
            if let error = error {
                self?.view.displayLoginErrorAlert(error: error)
                return
            }
            self?.output?.startAuthorizedFlow()
        }
    }

    func onTapSendResetPassword(email: String?) {
        guard let email = email,
              validateEmail(text: email) else {
            view?.displayResetPasswordNotValidAlert()
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            if let error = error {
                self?.view?.displayLoginErrorAlert(error: error)
                return
            }
            self?.view?.displayResetPasswordSentSuccessfullyAlert()
        }
    }

    func onTapSignInWithApple() {
        appleAuthService.completion = { [weak self] error in
            if let error = error {
                self?.view.displayLoginErrorAlert(error: error)
                return
            }
            self?.output?.startAuthorizedFlow()
        }
        appleAuthService.performSignInWithApple(contextProvider: view)
    }
}
