//
//  UserDataService.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 1.06.23.
//


final class UserDataService {
    @UserDataStorage(key: UserDefaultsKey.savedChecklists) private var savedChecklists: [ChecklistGroupStorageModel]?

    func clearUserData() {
        savedChecklists = nil
    }
}
