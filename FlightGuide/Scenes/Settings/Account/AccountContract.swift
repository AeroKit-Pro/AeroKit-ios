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
    func displayAccountDeletionErrorAlert(error: Error)
}

protocol AccountViewModelInterface: AnyObject {
    func viewDidLoad()
    func onTapDeleteAccount()
    func onConfirmDeleteAccount()
}

protocol AccountSceneOutput: AnyObject {
    func didTapLogout()
}
