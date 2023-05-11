//
//  RunwaySurface.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 5.05.23.
//

enum RunwaySurface: CaseIterable {
    case asphalt
    case grass
    case concrete
    case turf
    case gravel
    case water
}

extension RunwaySurface: ModelTitlable {
    var title: String {
        switch self {
        case .asphalt:
            return "Asphalt"
        case .grass:
            return "Grass"
        case .concrete:
            return "Concrete"
        case .turf:
            return "Turf"
        case .gravel:
            return "Gravel"
        case .water:
            return "Water"
        }
    }
}
