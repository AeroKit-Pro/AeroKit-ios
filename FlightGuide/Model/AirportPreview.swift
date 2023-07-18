//
//  AirportPreview.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 28.04.2023.
//
/// Airport preview info
struct AirportPreview: Decodable {
    let id: Int
    let name: String?
    let type: String?
    let municipality: String?
    let surfaces: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case municipality
        case surfaces
    }
}
