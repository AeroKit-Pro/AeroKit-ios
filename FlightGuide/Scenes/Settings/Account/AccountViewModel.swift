//
//  AccountViewModel.swift
//  HeyDay
//
//  Created by Eugene Kleban on 27.05.22.
//  
//

import Foundation
import FirebaseAuth

final class AccountViewModel {
    // MARK: Properties
    weak var view: AccountViewInterface!
    weak var output: AccountSceneOutput?

    // MARK: Methods
    init(view: AccountViewInterface) {
        self.view = view
    }
}

// MARK: AccountPresenterInterface
extension AccountViewModel: AccountViewModelInterface {
    func viewDidLoad() {
    }

    func onTapDeleteAccount() {
        view?.displayDeleteConfirmationAlert()
    }

    func onConfirmDeleteAccount() {
        Auth.auth().currentUser?.delete { [weak self] error in
          if let error = error {
              self?.view.displayAccountDeletionErrorAlert(error: error)
          } else {
              self?.output?.didTapLogout()
          }
        }
    }
}
