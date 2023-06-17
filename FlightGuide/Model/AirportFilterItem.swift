//
//  AirportFilterItem.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 5.05.23.
//

enum AirportFilterItem: Int, CaseIterable {
    case all
    case cities
    case airports
}

extension AirportFilterItem: ModelTitlable {
    var title: String {
        switch self {
        case .all:
            return "All"
        case .cities:
            return "Cities"
        case .airports:
            return "Airports"
        }
    }
}

extension AirportFilterItem: Indexable {
    var index: Int {
        self.rawValue
    }
}
