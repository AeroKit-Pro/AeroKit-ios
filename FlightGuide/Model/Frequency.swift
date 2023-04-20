//
//  Frequency.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 15.04.2023.
//

struct Frequencies: Codable {
    let items: [Frequency]
}

struct Frequency: Codable {
    let id: Int
    let airportID: Int?
    let type, description: String?
    let frequencyMhz: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case airportID = "airport_id"
        case type, description
        case frequencyMhz = "frequency_mhz"
    }
}
