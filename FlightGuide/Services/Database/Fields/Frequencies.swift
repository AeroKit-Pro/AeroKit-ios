//
//  Frequencies.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 28.04.2023.
//

import SQLite

struct FrequencyFields {
    let id = Expression<Int>("id")
    let airportID = Expression<Int?>("airport_id")
    let type = Expression<String?>("type")
    let description = Expression<String?>("description")
    let frequencyMhz = Expression<Double?>("frequency_mhz")
}
