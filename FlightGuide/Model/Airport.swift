//
//  Airport.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 30.03.2023.
//

struct Airports: Codable {
    let items: [Airport]
}

struct Airport: Codable {
    let id: Int
    let ident, type, name: String?
    let latitudeDeg, longitudeDeg: Double?
    let elevationFt: Int?
    let regionCode, municipality, scheduledService, gpsCode: String?
    let iataCode, localCode, homeLink, wikipediaLink, surfaces: String?
    let keywords: String?

    enum CodingKeys: String, CodingKey {
        case id, ident, type, name
        case latitudeDeg = "latitude_deg"
        case longitudeDeg = "longitude_deg"
        case elevationFt = "elevation_ft"
        case regionCode = "region_code"
        case municipality
        case scheduledService = "scheduled_service"
        case gpsCode = "gps_code"
        case iataCode = "iata_code"
        case localCode = "local_code"
        case homeLink = "home_link"
        case wikipediaLink = "wikipedia_link"
        case keywords
        case surfaces
    }
}
