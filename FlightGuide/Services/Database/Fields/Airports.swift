//
//  Airports.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 28.04.2023.
//

import SQLite

struct AirportColumns {
    let id = Expression<Int>("id")
    let ident = Expression<String?>("ident")
    let type = Expression<String?>("type")
    let name = Expression<String?>("name")
    let latitudeDeg = Expression<Double?>("latitude_deg")
    let longitudeDeg = Expression<Double?>("longitude_deg")
    let elevationFt = Expression<Int?>("elevation_ft")
    let regionCode = Expression<String?>("region_code")
    let municipality = Expression<String?>("municipality")
    let scheduledService = Expression<String?>("scheduled_service")
    let gpsCode = Expression<String?>("gps_code")
    let iataCode = Expression<String?>("iata_code")
    let localCode = Expression<String?>("local_code")
    let homeLink = Expression<String?>("home_link")
    let wikipediaLink = Expression<String?>("wikipedia_link")
    let surfaces = Expression<String?>("surfaces")
    let keywords = Expression<String?>("keywords")
    let isFavorite = Expression<Bool>("is_favorite")
}
