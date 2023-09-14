//
//  UserDataService.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 1.06.23.
//


final class UserDataService {
    @UserDataStorage(key: UserDefaultsKey.savedChecklists) private var savedChecklists: [ChecklistGroupStorageModel]?
    @UserDataStorage(key: UserDefaultsKey.savedIdObjectWithDate)
    private var savedFavorites: [IdObjectWithDate]?

    func clearUserData() {
        savedChecklists = nil
        savedFavorites = nil
    }
}
