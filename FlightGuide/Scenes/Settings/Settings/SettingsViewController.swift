//
//  SettingsViewController.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 2.07.23.
//

import UIKit

final class SettingsViewController: UIViewController {

    // MARK: Properties
    private let settingsView = SettingsView()
    var viewModel: SettingsViewModelInterface?

    // MARK: Lifecycle
    override func loadView() {
        view = settingsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel?.viewDidLoad()
        setupLayout()
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = "Settings"
        settingsView.logoutButton.addAction(UIAction { [weak self] _ in self?.viewModel?.onTapLogout() },
                               for: .touchUpInside)
        settingsView.onTapItem = { [weak self] item in
            switch item {
            case .aboutUs:
                self?.viewModel?.onTapAboutUs()
            case .account:
                self?.viewModel?.onTapAccount()
            }
        }
    }

    private func setupLayout() {
    }
}

// MARK: SettingsViewInterface
extension SettingsViewController: SettingsViewInterface {
}
