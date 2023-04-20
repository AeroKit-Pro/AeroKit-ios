//
//  City.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 15.04.2023.
//

struct Citites: Codable {
    let items: [City]
}

// MARK: - Item
struct City: Codable {
    let municipality: String?
    let closedAmount, heliportAmount, largeAirportAmount, mediumAirportAmount: Int?
    let seaplaneBaseAmount, smallAirportAmount, balloonportAmount: Int?

    enum CodingKeys: String, CodingKey {
        case municipality
        case closedAmount = "closed_amount"
        case heliportAmount = "heliport_amount"
        case largeAirportAmount = "large_airport_amount"
        case mediumAirportAmount = "medium_airport_amount"
        case seaplaneBaseAmount = "seaplane_base_amount"
        case smallAirportAmount = "small_airport_amount"
        case balloonportAmount = "balloonport_amount"
    }
}
