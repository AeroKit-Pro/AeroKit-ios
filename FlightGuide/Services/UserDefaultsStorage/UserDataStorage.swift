//
//  UserDataStorage.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 1.06.23.
//

import Foundation

enum UserDefaultsKey {
    static let savedChecklists = "com.aerokit.savedChecklists"
}

@propertyWrapper
struct UserDataStorage<T: Codable> {
    private let key: String

    private let userDefaults = UserDefaults.standard

    init(key: String) {
        self.key = key
    }

    var wrappedValue: T? {
        get {
            return (userDefaults.object(forKey: key) as? Data).flatMap {
                try? JSONDecoder().decode(T.self, from: $0)
            }
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                userDefaults.set(data, forKey: key)
            }
        }
    }
}
