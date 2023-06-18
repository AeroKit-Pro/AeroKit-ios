//
//  SignUpViewController.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 17.06.23.
//  
//

import UIKit

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

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(tapGesture)

        signUpView.signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
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
}

// MARK: SignUpViewInterface
extension SignUpViewController: SignUpViewInterface {
    func displayNameErrorState(isErrorState: Bool, error: String) {
        signUpView.userNameContainerView.setState(isError: isErrorState, errorMessage: error)
    }

    func displayEmailErrorState(isErrorState: Bool, error: String) {
        signUpView.emailContainerView.setState(isError: isErrorState, errorMessage: error)
    }

    func displayPasswordErrorState(isErrorState: Bool, error: String) {
        signUpView.passwordContainerView.setState(isError: isErrorState, errorMessage: error)
    }
}
