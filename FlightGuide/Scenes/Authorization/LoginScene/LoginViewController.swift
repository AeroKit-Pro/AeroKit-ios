//
//  LoginViewController.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 17.06.23.
//  
//

import UIKit

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

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(tapGesture)

        loginView.signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
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
}

// MARK: LoginView Protocol
extension LoginViewController: LoginViewInterface {
    func displayEmailErrorState(isErrorState: Bool, error: String) {
        loginView.userNameContainerView.setState(isError: isErrorState, errorMessage: error)
    }

    func displayPasswordErrorState(isErrorState: Bool, error: String) {
        loginView.passwordContainerView.setState(isError: isErrorState, errorMessage: error)
    }
}
