//
//  ChecklistGroupStorageModel.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 5.06.23.
//

import Foundation

struct ChecklistGroupStorageModel: Codable, Equatable {
    let id: Int
    let date: Date
    let name: String
    let fullPlaneName: String
    let isFullChecklistModel: Bool
    let checklists: [ChecklistWithItemsModel]
}
