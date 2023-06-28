//
//  APIRequest.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 30.03.2023.
//

import Foundation
import Alamofire

typealias Path = [String]
typealias Headers = [String : String]

enum APIRequest: URLRequestConvertible {
    case getAirports
    case getRunways
    case getFrequencies
    case getCities
    case getChecklists
    case getWeather(type: WeatherReportType, icao: String)
    case createChatCompletions(parameters: Data?)
}

extension APIRequest {
    
    internal func asURLRequest() throws -> URLRequest {
        var url = try url.asURL()
        if let path { url.appendPathComponents(path) }
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = body
        
        return urlRequest
    }
    
    private var url: String {
        switch self {
        case .getAirports: return URLS.airportsEndpoint
        case .getRunways: return URLS.airportRunwaysEndpoint
        case .getFrequencies: return URLS.airportFrequencyEndpoint
        case .getCities: return URLS.citiesInfoEndpoint
        case .getWeather: return URLS.weatherBaseUrl
        case .getChecklists: return URLS.checklistsUrl
        case .createChatCompletions: return URLS.openaiBaseUrl
        }
    }
    
    private var path: Path? {
        switch self {
        case .getWeather(let type, let icao): return [type.path, icao]
        default: return nil
        }
    }
    
    private var headers: Headers? {
        switch self {
        case .getWeather: return HTTPHeaders.weatherApiKey
        case .createChatCompletions: return HTTPHeaders.openaiRequiredHeaders
        default: return nil
        }
    }
    
    private var body: Data? {
        switch self {
        case .createChatCompletions(let parameters): return parameters
        default: return nil
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .getAirports, .getRunways, .getFrequencies, .getCities, .getWeather, .getChecklists:
            return .get
        case .createChatCompletions:
            return .post
        }
    }

}
