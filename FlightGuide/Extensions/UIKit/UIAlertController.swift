//
//  UIAlertController.swift
//  Parilet
//
//  Created by Vanya Bogdantsev on 22.04.2023.
//

import UIKit
import Foundation

extension UIAlertController {
    static func promptToEnableLocation() -> UIAlertController {
        let alertController = UIAlertController(
            title: "Turn on location services to allow to determine your location",
            message: "Your location will only be used for navigation purposes",
            preferredStyle: .alert
        )
        alertController.addAction(
            UIAlertAction(
                title: "Go to settings",
                style: .default,
                handler: { _ in
                    if let bundleId = Bundle.main.bundleIdentifier,
                        let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)")
                    {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            )
        )
        alertController.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .default,
                handler: nil
            )
        )
        return alertController
    }
}
