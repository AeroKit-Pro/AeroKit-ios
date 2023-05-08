//
//  AirportFilterItem.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 5.05.23.
//

enum AirportFilterItem: CaseIterable {
    case all
    case cities
    case airports

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
