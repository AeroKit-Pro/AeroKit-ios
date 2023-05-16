//
//  Runways.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 28.04.2023.
//

import SQLite

struct RunwayFields {
    let id = Expression<Int>("runway_id")
    let airportID = Expression<Int?>("airport_id")
    let lengthFt = Expression<Int?>("length_ft")
    let widthFt = Expression<Int?>("width_ft")
    let heDisplacedThresholdFt = Expression<Int?>("he_displaced_threshold_ft")
    let leElevationFt = Expression<Int?>("le_elevation_ft")
    let leDisplacedThresholdFt = Expression<Int?>("le_displaced_threshold_ft")
    let heElevationFt = Expression<Int?>("he_elevation_ft")
    let surface = Expression<String?>("surface")
    let leIdent = Expression<String?>("le_ident")
    let heIdent = Expression<String?>("he_ident")
    let lighted = Expression<Bool?>("lighted")
    let closed = Expression<Bool?>("closed")
    let leLatitudeDeg = Expression<Double?>("le_latitude_deg")
    let leLongitudeDeg = Expression<Double?>("le_longitude_deg")
    let leHeadingDegT = Expression<Double?>("le_heading_degT")
    let heLatitudeDeg = Expression<Double?>("he_latitude_deg")
    let heLongitudeDeg = Expression<Double?>("he_longitude_deg")
    let heHeadingDegT = Expression<Double?>("he_heading_degT")
}
