//
//  Runway.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 15.04.2023.
//

struct Runways: Codable {
    let items: [Runway]
}

struct Runway: Codable {
    let id: Int
    let airportID, lengthFt, widthFt, heDisplacedThresholdFt: Int?
    let leElevationFt, leDisplacedThresholdFt, heElevationFt: Int?
    let surface, leIdent, heIdent: String?
    let lighted, closed: Bool?
    let leLatitudeDeg, leLongitudeDeg, leHeadingDegT: Double?
    let heLatitudeDeg, heLongitudeDeg, heHeadingDegT: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case airportID = "airport_id"
        case lengthFt = "length_ft"
        case widthFt = "width_ft"
        case surface, lighted, closed
        case leIdent = "le_ident"
        case leLatitudeDeg = "le_latitude_deg"
        case leLongitudeDeg = "le_longitude_deg"
        case leElevationFt = "le_elevation_ft"
        case leHeadingDegT = "le_heading_degT"
        case leDisplacedThresholdFt = "le_displaced_threshold_ft"
        case heIdent = "he_ident"
        case heLatitudeDeg = "he_latitude_deg"
        case heLongitudeDeg = "he_longitude_deg"
        case heElevationFt = "he_elevation_ft"
        case heHeadingDegT = "he_heading_degT"
        case heDisplacedThresholdFt = "he_displaced_threshold_ft"
    }
}
