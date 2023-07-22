//
//  AccountViewController.swift
//  HeyDay
//
//  Created by Eugene Kleban on 27.05.22.
//  
//

import UIKit

final class AccountViewController: UIViewController {

    // MARK: Properties
    let accountView = AccountView()
    var viewModel: AccountViewModelInterface?

    // MARK: Lifecycle
    override func loadView() {
        view = accountView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Account"
        viewModel?.viewDidLoad()

        accountView.deleteAccountButton.addAction(UIAction(handler: { [weak self] _ in self?.viewModel?.onTapDeleteAccount()}),
                                                  for: .touchUpInside)
        accountView.changePasswordButton.addAction(UIAction(handler: { [weak self] _ in self?.viewModel?.onTapChangePassword()}),
                                                  for: .touchUpInside)
    }
}

// MARK: AccountView Protocol
extension AccountViewController: AccountViewInterface {
    func displayDeleteConfirmationAlert() {
        let alert = UIAlertController(title: "Сonfirm account deletion",
                                      message: "Are you sure you want to delete your account?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm",
                                      style: .default,
                                      handler: { [weak self] _ in
            self?.viewModel?.onConfirmDeleteAccount()
        }))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil))

        present(alert, animated: true, completion: nil)
    }


    func displayAccountDeletionErrorAlert(error: Error) {
        let alert = UIAlertController(title: "Account deletion error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
