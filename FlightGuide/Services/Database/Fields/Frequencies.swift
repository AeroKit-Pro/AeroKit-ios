//
//  Frequencies.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 28.04.2023.
//

import SQLite

struct FrequencyFields {
    let frequency_id = Expression<Int>("frequency_id")
    let usedByAirport_id = Expression<Int?>("usedByAirport_id")
    let frequency_type = Expression<String?>("frequency_type")
    let description = Expression<String?>("description")
    let frequencyMhz = Expression<Double?>("frequencyMhz")
}
