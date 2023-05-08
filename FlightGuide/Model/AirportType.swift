//
//  AirportType.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 5.05.23.
//

enum AirportType: CaseIterable {
    case small
    case large
    case medium
    case closed
    case heliport
    case seaPlane
    case baloonPlane
}

extension AirportType: ModelTitlable {
    var title: String {
        switch self {
        case .small:
            return "Small"
        case .large:
            return "Large"
        case .medium:
            return "Medium"
        case .closed:
            return "Closed"
        case .heliport:
            return "Heliport"
        case .seaPlane:
            return "Sea-plane"
        case .baloonPlane:
            return "Baloon-plane"
        }
    }
}
