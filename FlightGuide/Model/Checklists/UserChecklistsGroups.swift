//
//  UserChecklistsGroups.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 4.08.23.
//

import Foundation

struct UserChecklistsGroups: Codable {
    struct UserChecklistsGroup: Codable {
        let name: String
        let checklists_ids: [Int]
        let id: Int
    }

    let checklists_groups: [UserChecklistsGroup]
}


struct UserChecklistsGroupBase: Codable {
    let name: String
    let checklists_ids: [Int]
}
