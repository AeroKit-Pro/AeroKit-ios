//
//  Runways.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 28.04.2023.
//

import SQLite

struct RunwayFields {
    let runway_id = Expression<Int>("runway_id")
    let airport_id = Expression<Int?>("airport_id")
    let lengthFt = Expression<Int?>("lengthFt")
    let widthFt = Expression<Int?>("widthFt")
    let heDisplacedThresholdFt = Expression<Int?>("heDisplacedThresholdFt")
    let leElevationFt = Expression<Int?>("leElevationFt")
    let leDisplacedThresholdFt = Expression<Int?>("leDisplacedThresholdFt")
    let heElevationFt = Expression<Int?>("heElevationFt")
    let surface = Expression<String?>("surface")
    let leIdent = Expression<String?>("leIdent")
    let heIdent = Expression<String?>("heIdent")
    let lighted = Expression<Bool?>("lighted")
    let closed = Expression<Bool?>("closed")
    let leLatitudeDeg = Expression<Double?>("leLatitudeDeg")
    let leLongitudeDeg = Expression<Double?>("leLongitudeDeg")
    let leHeadingDegT = Expression<Double?>("leHeadingDegT")
    let heLatitudeDeg = Expression<Double?>("heLatitudeDeg")
    let heLongitudeDeg = Expression<Double?>("heLongitudeDeg")
    let heHeadingDegT = Expression<Double?>("heHeadingDegT")
}
