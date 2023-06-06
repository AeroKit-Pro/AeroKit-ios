//
//  APIRequest.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 30.03.2023.
//

import Foundation
import Alamofire

enum APIRequest: URLRequestConvertible {
    case getAirports
    case getRunways
    case getFrequencies
    case getCities
    case getChecklists
}

extension APIRequest {
    
    internal func asURLRequest() throws -> URLRequest {
        let url = try url.asURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue

        return urlRequest
    }

    private var method: HTTPMethod {
        switch self {
        case .getAirports, .getRunways, .getFrequencies, .getCities, .getChecklists:
            return .get
        }
    }
    
    private var url: String {
        switch self {
        case .getAirports: return NetworkingConstants.airportsUrl
        case .getRunways: return NetworkingConstants.airportRunwaysUrl
        case .getFrequencies: return NetworkingConstants.airportFrequencyUrl
        case .getCities: return NetworkingConstants.citiesInfoUrl
        case .getChecklists: return NetworkingConstants.checklistsUrl
        }
    }

}
