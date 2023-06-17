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
        case id = "frequency_id" // change to "id" for making an API call. TODO: fix db rows naming
        case airportID = "id_airport" // change to "airport_id" for making an API call. TODO: fix db rows naming
        case type = "frequency_type" // change to "type" for making an API call. TODO: fix db rows
        case description
        case frequencyMhz = "frequency_mhz"
    }
}
