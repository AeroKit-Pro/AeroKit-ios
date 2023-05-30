//
//  CityPreview.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 30.05.2023.
//

struct AirportByCity: Decodable {
    let id: Int
    let type: String?
    let municipality: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case municipality
    }
}
