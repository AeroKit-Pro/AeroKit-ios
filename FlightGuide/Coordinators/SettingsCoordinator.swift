//
//  SettingsCoordinator.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 2.07.23.
//

import Foundation
import SafariServices
import MessageUI

final class SettingsCoordinator: BaseCoordinator {
    var onTapLogout: (() -> Void)?

    // MARK: - Lifecycle
    override func start() {
        openSettings()
    }

    func openSettings() {
        let scene = SettingsAssembly(sceneOutput: self).makeScene()
        startingViewController = scene
        router.setRootModule(scene, hideBar: true)
    }
}

// MARK: - SettingsSceneOutput
extension SettingsCoordinator: SettingsSceneOutput {
    func showAccountScene() {
        let scene = AccountAssembly(sceneOutput: self).makeScene()
        router.push(scene, animated: true)
    }

    func showAboutUsScene() {
        let scene = AboutViewController(nibName: nil, bundle: nil)
        scene.onTapPrivacyPolicy = { [weak self] in
            self?.openPrivacyPolicy()
        }
        scene.onTapOurWebsite = { [weak self] in
            self?.openOurWebsite()
        }
        scene.onTapSendEmail = { [weak self] in
            self?.openSendEmail()
        }

        router.push(scene, animated: true)
    }

    func didTapLogout() {
        onTapLogout?()
    }

    func openPrivacyPolicy() {
        let reader = PDFReaderViewController(fileURL: InfoURLs.privacyPolicyURL)
        router.push(reader, animated: true)
    }

    func openOurWebsite() {
        let vc = SFSafariViewController(url: InfoURLs.ourWebsiteURL)
        router.present(vc, animated: true)
    }

    func openSendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.mailComposeDelegate = self
            mailComposeViewController.setToRecipients([InfoURLs.supportEmail])
            mailComposeViewController.setSubject("Message Subject")
            mailComposeViewController.setMessageBody("Message content", isHTML: false)
            router.present(mailComposeViewController, animated: true)
        }
    }
}

// MARK: - AccountSceneOutput
extension SettingsCoordinator: AccountSceneOutput {

}

extension SettingsCoordinator: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
