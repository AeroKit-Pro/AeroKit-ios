//
//  SignUpViewController.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 17.06.23.
//  
//

import AuthenticationServices
import UIKit
import GoogleSignIn

final class SignUpViewController: UIViewController {

    // MARK: Properties
    private let signUpView = SignUpView()
    var viewModel: SignUpViewModelInterface?

    // MARK: Lifecycle
    override func loadView() {
        view = signUpView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(tapGesture)

        signUpView.signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        signUpView.socialAuthorizationBlockView.gooogleButton.addTarget(self, action: #selector(didTapSignUpWithGoogle), for: .touchUpInside)
        signUpView.socialAuthorizationBlockView.appleButton.addTarget(self, action: #selector(didTapSignUpWithApple), for: .touchUpInside)
        viewModel?.viewDidLoad()
    }

    @objc
    private func didTapView() {
        signUpView.endEditing(true)
    }

    @objc
    private func didTapSignUp() {
        viewModel?.onTapSignUp(email: signUpView.emailContainerView.textField.text,
                               name: signUpView.userNameContainerView.textField.text,
                               password: signUpView.passwordContainerView.textField.text)
    }

    @objc
    private func didTapSignUpWithApple() {
        viewModel?.onTapSignInWithApple()
    }

    @objc
    private func didTapSignUpWithGoogle() {
        viewModel?.onTapSignInWithGoogle()
    }
}

// MARK: SignUpViewInterface
extension SignUpViewController: SignUpViewInterface {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        view.window!
    }

    func displayNameErrorState(isErrorState: Bool, error: String) {
        signUpView.userNameContainerView.setState(isError: isErrorState, errorMessage: error)
    }

    func displayEmailErrorState(isErrorState: Bool, error: String) {
        signUpView.emailContainerView.setState(isError: isErrorState, errorMessage: error)
    }

    func displayPasswordErrorState(isErrorState: Bool, error: String) {
        signUpView.passwordContainerView.setState(isError: isErrorState, errorMessage: error)
    }

    func displayLoginErrorAlert(error: Error) {
        let alert = UIAlertController(title: "Authorization error", message: error.localizedDescription, preferredStyle: .alert)
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
