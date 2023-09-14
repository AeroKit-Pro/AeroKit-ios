//
//  NotificationToken.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 26.05.2023.
//

import Foundation

final class NotificationToken: NSObject {
    let notificationCenter: NotificationCenter
    let token: Any

    init(notificationCenter: NotificationCenter = .default, token: Any) {
        self.notificationCenter = notificationCenter
        self.token = token
    }

    deinit {
        notificationCenter.removeObserver(token)
    }
}
