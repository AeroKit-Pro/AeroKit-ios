//
//  DIContainer.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 26.05.2023.
//

import Foundation

final class DIContainer {
    static let `default` = DIContainer()

    let notificationService: NotificationCenterModuleInterface

    init() {
        self.notificationService = NotificationCenter.default
    }
}
