//
//  SignUpContract.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 17.06.23.
//  
//

import AuthenticationServices
import GoogleSignIn

protocol SignUpViewInterface: AnyObject,
                              DisplayLoaderInterface,
                              ASAuthorizationControllerPresentationContextProviding {
    func displayPasswordErrorState(isErrorState: Bool, error: String)
    func displayNameErrorState(isErrorState: Bool, error: String)
    func displayEmailErrorState(isErrorState: Bool, error: String)
    func displayLoginErrorAlert(error: Error)
    func displaySignInWithGoogle()
}

protocol SignUpViewModelInterface: AnyObject {
    func viewDidLoad()
    func onTapSignUp(email: String?, name: String?, password: String?)
    func onTapSignInWithGoogle()
    func onSignInWithGoogleResult(result: GIDSignInResult?, error: Error?)
    func onTapSignInWithApple()
}

protocol SignUpSceneOutput: AnyObject {
    func startAuthorizedFlow()
}
