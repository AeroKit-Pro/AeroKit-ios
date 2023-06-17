//
//  NotificationCentre.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 26.05.2023.
//

import Foundation

protocol NotificationCenterModuleInterface: AnyObject {
    func observe(
        name: NSNotification.Name?,
        object: Any?,
        queue: OperationQueue?,
        using block: @escaping (Notification) -> Void
    ) -> NotificationToken

    func observe(
        names: [NSNotification.Name?],
        using block: @escaping (Notification) -> Void
    ) -> [NotificationToken]

    func post(
        name aName: NSNotification.Name,
        object anObject: Any?,
        userInfo aUserInfo: [AnyHashable: Any]?
    )
}

extension NotificationCenterModuleInterface {

    func observe(
        name: NSNotification.Name?,
        object: Any? = nil,
        queue: OperationQueue? = nil,
        using block: @escaping (Notification) -> Void
    ) -> NotificationToken {
        observe(name: name, object: object, queue: queue, using: block)
    }

    func observe(
        name: NSNotification.Name?,
        using block: @escaping (Notification) -> Void
    ) -> NotificationToken {
        observe(name: name, object: nil, queue: nil, using: block)
    }

    func observe(
        names: [NSNotification.Name?],
        using block: @escaping (Notification) -> Void
    ) -> [NotificationToken] {
        names.map {
            observe(name: $0, object: nil, queue: nil, using: block)
        }
    }

    func post(
        name aName: NSNotification.Name,
        object anObject: Any?,
        userInfo aUserInfo: [AnyHashable: Any]?
    ) {
        post(name: aName, object: anObject, userInfo: aUserInfo)
    }

    func post(
        name aName: NSNotification.Name,
        object anObject: Any? = nil
    ) {
        post(name: aName, object: anObject, userInfo: nil)
    }
}

extension NotificationCenter: NotificationCenterModuleInterface { }

extension NotificationCenter {
    func observe(name: NSNotification.Name?,
                 object: Any? = nil,
                 queue: OperationQueue? = nil,
                 using block: @escaping (Notification) -> Void) -> NotificationToken {
        let token = addObserver(forName: name, object: object, queue: queue, using: block)
        return NotificationToken(notificationCenter: self, token: token)
    }
    
    func observe(name: NSNotification.Name?,
                 object: Any? = nil,
                 queue: OperationQueue? = nil,
                 using block: @escaping () -> Void) -> NotificationToken {
        let token = addObserver(forName: name, object: object, queue: queue) { _ in
            block()
        }
        return NotificationToken(notificationCenter: self, token: token)
    }
}
