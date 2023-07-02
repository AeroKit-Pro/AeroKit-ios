//
//  LoginViewController.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 17.06.23.
//  
//

import UIKit
import GoogleSignIn
import AuthenticationServices

final class LoginViewController: UIViewController {

    // MARK: Properties
    private let loginView = LoginView()
    var viewModel: LoginViewModelInterface?

    // MARK: Lifecycle
    override func loadView() {
        view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(tapGesture)

        loginView.loginButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        loginView.socialAuthorizationBlockView.gooogleButton.addTarget(self, action: #selector(didTapSignUpWithGoogle), for: .touchUpInside)
        loginView.socialAuthorizationBlockView.appleButton.addTarget(self, action: #selector(didTapSignUpWithApple), for: .touchUpInside)
        loginView.resetPasswordButton.addTarget(self, action: #selector(didTapResetPassword), for: .touchUpInside)
        viewModel?.viewDidLoad()
    }

    @objc
    private func didTapView() {
        loginView.endEditing(true)
    }

    @objc
    private func didTapSignUp() {
        viewModel?.onTapSignIn(email: loginView.userNameContainerView.textField.text, password: loginView.passwordContainerView.textField.text)
    }

    @objc
    private func didTapSignUpWithGoogle() {
        viewModel?.onTapSignInWithGoogle()
    }

    @objc
    private func didTapSignUpWithApple() {
        viewModel?.onTapSignInWithApple()
    }

    @objc
    private func didTapResetPassword() {
        displayResetPasswordAlert()
    }

    private func displayResetPasswordAlert() {
        var textFieldText: String?
        let dialogMessage = UIAlertController(title: "Reset password", message: "Enter your email", preferredStyle: .alert)
        let createAction = UIAlertAction(title: "Send", style: .default, handler: { [weak self] action -> Void in
            self?.viewModel?.onTapSendResetPassword(email: textFieldText)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        dialogMessage.addAction(createAction)
        dialogMessage.addAction(cancelAction)
        dialogMessage.addTextField { textField -> Void in
            textFieldText = textField.text
        }

        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }

}

// MARK: LoginView Protocol
extension LoginViewController: LoginViewInterface {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        view.window!
    }

    func displayEmailErrorState(isErrorState: Bool, error: String) {
        loginView.userNameContainerView.setState(isError: isErrorState, errorMessage: error)
    }

    func displayPasswordErrorState(isErrorState: Bool, error: String) {
        loginView.passwordContainerView.setState(isError: isErrorState, errorMessage: error)
    }

    func displayLoginErrorAlert(error: Error) {
        let alert = UIAlertController(title: "Authorization error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func displayResetPasswordNotValidAlert() {
        let alert = UIAlertController(title: "Reset password error", message: "Not valid email", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func displayResetPasswordSentSuccessfullyAlert() {
        let alert = UIAlertController(title: "Reset password", message: "Sent successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }


    func displaySignInWithGoogle() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, error in
            self?.viewModel?.onSignInWithGoogleResult(result: result, error: error)
        }
    }
}
