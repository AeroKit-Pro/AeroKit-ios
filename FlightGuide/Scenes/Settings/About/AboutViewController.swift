//
//  AboutViewController.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 6.07.23.
//

import UIKit

final class AboutViewController: UIViewController {
    let aboutView = AboutView()

    var onTapPrivacyPolicy: (() -> Void)?
    var onTapOurWebsite: (() -> Void)?
    var onTapSendEmail: (() -> Void)?

    override func loadView() {
        view = aboutView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "About us"

        aboutView.privacyPolicyButton.addAction(UIAction(handler: { [weak self] _ in self?.onTapPrivacyPolicy?() }),
                                                for: .touchUpInside)

        aboutView.ourWebsiteButton.addAction(UIAction(handler: { [weak self] _ in self?.onTapOurWebsite?() }),
                                             for: .touchUpInside)

        aboutView.emailToContactButton.addAction(UIAction(handler: { [weak self] _ in self?.onTapSendEmail?() }),
                                             for: .touchUpInside)

    }
}
