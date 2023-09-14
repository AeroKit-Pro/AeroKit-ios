//
//  LoginContract.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 17.06.23.
//  
//

import AuthenticationServices
import GoogleSignIn

protocol LoginViewInterface: AnyObject,
                             DisplayLoaderInterface,
                             ASAuthorizationControllerPresentationContextProviding {
    func displayPasswordErrorState(isErrorState: Bool, error: String)
    func displayEmailErrorState(isErrorState: Bool, error: String)
    func displayLoginErrorAlert(error: Error)
    func displaySignInWithGoogle()
    func displayResetPasswordNotValidAlert() 
    func displayResetPasswordSentSuccessfullyAlert()
}

protocol LoginViewModelInterface: AnyObject {
    func viewDidLoad()
    func onTapSignIn(email: String?, password: String?)
    func onTapSignInWithGoogle()
    func onSignInWithGoogleResult(result: GIDSignInResult?, error: Error?)
    func onTapSendResetPassword(email: String?)
    func onTapSignInWithApple()
}

protocol LoginSceneOutput: AnyObject {
    func startAuthorizedFlow()
}
