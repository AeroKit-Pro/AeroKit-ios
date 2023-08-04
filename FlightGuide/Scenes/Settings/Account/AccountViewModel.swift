//
//  AccountViewModel.swift
//  HeyDay
//
//  Created by Eugene Kleban on 27.05.22.
//  
//

import Foundation
import FirebaseAuth
import RxSwift

final class AccountViewModel {
    // MARK: Properties
    weak var view: AccountViewInterface!
    weak var output: AccountSceneOutput?
    private let userDataService = UserDataService()
    private let apiClient = APIClient()
    private let disposeBag = DisposeBag()

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
        guard let id = Auth.auth().currentUser?.uid else { return }
        Auth.auth().currentUser?.delete { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.view.displayAccountDeletionErrorAlert(error: error)
            } else {
                self.apiClient.deleteAllUserData(id: id)
                    .subscribe { [weak self] event in
                        switch event {
                        case .next:
                            self?.userDataService.clearUserData()
                            self?.output?.didTapLogout()
                        default:
                            break
                        }
                    }.disposed(by: self.disposeBag)
            }
        }
    }

    func onTapChangePassword() {
        guard let email = FirebaseAuth.Auth.auth().currentUser?.email else { return }
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            if let error = error {
                self?.view?.displayChangePasswordErrorAlert(error: error)
                return
            }
            self?.view?.displayChangePasswordSentSuccessfullyAlert()
        }
    }
}
