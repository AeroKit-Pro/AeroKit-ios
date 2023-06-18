//
//  LoginContract.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 17.06.23.
//  
//

import Foundation

protocol LoginViewInterface: AnyObject,
                             DisplayLoaderInterface {
    func displayPasswordErrorState(isErrorState: Bool, error: String)
    func displayEmailErrorState(isErrorState: Bool, error: String)
}

protocol LoginViewModelInterface: AnyObject {
    func viewDidLoad()
    func onTapSignIn(email: String?, password: String?)
}

protocol LoginSceneOutput: AnyObject {
    func startAuthorizedFlow()
}
