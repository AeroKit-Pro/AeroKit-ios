//
//  Frequencies.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 28.04.2023.
//

import SQLite

struct FrequencyFields {
    let id = Expression<Int>("frequency_id")
    let airportID = Expression<Int?>("id_airport")
    let type = Expression<String?>("frequency_type")
    let description = Expression<String?>("description")
    let frequencyMhz = Expression<Double?>("frequency_mhz")
}
