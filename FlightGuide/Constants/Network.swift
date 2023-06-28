//
//  Network.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 30.03.2023.
//



protocol HTTPPathable {
    var path: String { get }
}

enum WeatherReportType {
    case metar
    case taf
}

extension WeatherReportType: HTTPPathable {
    var path: String {
        switch self {
        case .metar: return "metar"
        case .taf: return "taf"
        }
    }
}

enum HTTPHeaders {
    static let weatherApiKey = ["X-API-Key" : "7b7fd028c5504c7fa83ab2b9ac"]
    static let openaiRequiredHeaders = ["Content-Type": "application/json",
                                        "api-key": "4dcdd38ac23943a3911147f8690f2023"]
}

enum URLS {
    static let weatherBaseUrl = "https://api.checkwx.com"
    static let airportsEndpoint = "http://45.12.19.184/airports?page=1&page_size=5000"
    static let airportRunwaysEndpoint = "http://45.12.19.184/airport_runways?page=1&page_size=5000"
    static let airportFrequencyEndpoint = "http://45.12.19.184/airport_frequency?page=1&page_size=5000"
    static let citiesInfoEndpoint = "http://45.12.19.184/cities_info?page=1&page_size=50"
    static let checklistsUrl = "http://45.12.19.184/checklists"
    static let openaiBaseUrl = "https://aerokit-test.openai.azure.com/openai/deployments/test123/chat/completions?api-version=2023-03-15-preview"
}
