//
//  SettingsContract.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 2.07.23.
//

import Foundation

protocol SettingsViewInterface: AnyObject,
                                DisplayLoaderInterface {
}

protocol SettingsViewModelInterface: AnyObject {
    func viewDidLoad()
    func onTapLogout()
    func onTapAboutUs()
    func onTapAccount()
}

protocol SettingsSceneOutput: AnyObject {
    func didTapLogout()
    func showAccountScene()
    func showAboutUsScene()
}
