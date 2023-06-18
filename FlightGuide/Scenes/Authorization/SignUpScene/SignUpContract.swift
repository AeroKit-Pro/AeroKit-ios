//
//  SignUpContract.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 17.06.23.
//  
//

import Foundation

protocol SignUpViewInterface: AnyObject,
                              DisplayLoaderInterface {
    func displayPasswordErrorState(isErrorState: Bool, error: String)
    func displayNameErrorState(isErrorState: Bool, error: String)
    func displayEmailErrorState(isErrorState: Bool, error: String)
}

protocol SignUpViewModelInterface: AnyObject {
    func viewDidLoad()
    func onTapSignUp(email: String?, name: String?, password: String?)
}

protocol SignUpSceneOutput: AnyObject {
    func startAuthorizedFlow()
}
