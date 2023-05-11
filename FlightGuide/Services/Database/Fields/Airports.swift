//
//  Airports.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 28.04.2023.
//

import SQLite

struct AirportFields {
    let id = Expression<Int>("id")
    let ident = Expression<String?>("ident")
    let type = Expression<String?>("type")
    let name = Expression<String?>("name")
    let latitudeDeg = Expression<Double?>("latitudeDeg")
    let longitudeDeg = Expression<Double?>("longitudeDeg")
    let elevationFt = Expression<Int?>("elevationFt")
    let regionCode = Expression<String?>("regionCode")
    let municipality = Expression<String?>("municipality")
    let scheduledService = Expression<String?>("scheduledService")
    let gpsCode = Expression<String?>("gpsCode")
    let iataCode = Expression<String?>("iataCode")
    let localCode = Expression<String?>("localCode")
    let homeLink = Expression<String?>("homeLink")
    let wikipediaLink = Expression<String?>("wikipediaLink")
    let surfaces = Expression<String?>("surfaces")
    let keywords = Expression<String?>("keywords")
}
