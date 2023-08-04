//
//  SettingsViewModel.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 2.07.23.
//

import Foundation
import FirebaseAuth

final class SettingsViewModel {

    // MARK: Properties
    weak var view: SettingsViewInterface!
    weak var output: SettingsSceneOutput?
    private let userDataService = UserDataService()

    // MARK: Methods
    init(view: SettingsViewInterface) {
        self.view = view
    }
}

// MARK: SettingsViewModelInterface
extension SettingsViewModel: SettingsViewModelInterface {
    func viewDidLoad() {
    }

    func onTapLogout() {
        do {
            try Auth.auth().signOut()
            userDataService.clearUserData()
            output?.didTapLogout()
        } catch {
        }
    }

    func onTapAboutUs() {
        output?.showAboutUsScene()
    }

    func onTapAccount() {
        output?.showAccountScene()
    }
}
