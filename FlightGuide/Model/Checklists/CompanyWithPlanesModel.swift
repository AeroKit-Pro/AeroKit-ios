//
//  CompanyWithPlanesModel.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 2.06.23.
//

import Foundation

struct CompanyWithPlanesModel: Codable, Equatable {
    let id: Int
    let name: String
    let planes: [PlaneWithChecklistsModel]
}

struct PlaneWithChecklistsModel: Codable, Equatable {
    let id: Int
    let model: String
    let checklists: [ChecklistWithItemsModel]
}

struct ChecklistWithItemsModel: Codable, Equatable {
    let id: Int
    let type: String
    let items: [ChecklistItemModel]
}

struct ChecklistItemModel: Codable, Equatable {
    let id: Int
    let name: String
    let value: String
}
