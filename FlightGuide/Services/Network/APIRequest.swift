//
//  APIRequest.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 30.03.2023.
//

import Foundation
import Alamofire

typealias Headers = [String : String]

enum APIRequest: URLRequestConvertible {
    case getAirports
    case getRunways
    case getFrequencies
    case getCities
    case getWeather(type: WeatherReportType, icao: String)
}

extension APIRequest {
    
    internal func asURLRequest() throws -> URLRequest {
        var url = try url.asURL()
        if let path { url.appendPathComponents(path) }
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
    
    private var url: String {
        switch self {
        case .getAirports: return URLS.airportsEndpoint
        case .getRunways: return URLS.airportRunwaysEndpoint
        case .getFrequencies: return URLS.airportFrequencyEndpoint
        case .getCities: return URLS.citiesInfoEndpoint
        case .getWeather: return URLS.weatherBaseUrl
        }
    }
    
    private var path: [String]? {
        switch self {
        case .getWeather(let type, let icao): return [type.path, icao]
        default: return nil
        }
    }
    
    private var headers: Headers? {
        switch self {
        case .getWeather: return HTTPHeaders.weatherApiKey
        default: return nil
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .getAirports, .getRunways, .getFrequencies, .getCities, .getWeather:
            return .get
        }
    }

}
