//
//  Cities.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 15.05.2023.
//

import SQLite

struct CityFields {
    let municipality = Expression<String?>("municipality")
    let closedAmount = Expression<Int?>("closed_amount")
    let heliportAmount = Expression<Int?>("heliport_amount")
    let largeAirportAmount = Expression<Int?>("large_airport_amount")
    let mediumAirportAmount = Expression<Int?>("medium_airport_amount")
    let seaplaneBaseAmount = Expression<Int?>("seaplane_base_amount")
    let smallAirportAmount = Expression<Int?>("small_airport_amount")
    let balloonportAmount = Expression<Int?>("balloonport_amount")
}
