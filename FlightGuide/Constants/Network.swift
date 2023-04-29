//
//  Network.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 30.03.2023.
//

enum NetworkingConstants {
    static let airportsUrl = "http://45.12.19.184/airports?page=1&page_size=5000"
    
    static let airportRunwaysUrl = "http://45.12.19.184/airport_runways?page=1&page_size=5000"
    
    static let airportFrequencyUrl = "http://45.12.19.184/airport_frequency?page=1&page_size=5000"
    
    static let citiesInfoUrl = "http://45.12.19.184/cities_info?page=1&page_size=50"
}
