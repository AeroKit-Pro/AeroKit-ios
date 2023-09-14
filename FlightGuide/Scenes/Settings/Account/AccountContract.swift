//
//  AccountContract.swift
//  HeyDay
//
//  Created by Eugene Kleban on 27.05.22.
//  
//

import Foundation

protocol AccountViewInterface: AnyObject,
                               DisplayLoaderInterface {
    func displayDeleteConfirmationAlert()
    func displayChangePasswordErrorAlert(error: Error)
    func displayChangePasswordSentSuccessfullyAlert()
    func displayAccountDeletionErrorAlert(error: Error)
}

protocol AccountViewModelInterface: AnyObject {
    func viewDidLoad()
    func onTapDeleteAccount()
    func onConfirmDeleteAccount()
    func onTapChangePassword()
}

protocol AccountSceneOutput: AnyObject {
    func didTapLogout()
}
