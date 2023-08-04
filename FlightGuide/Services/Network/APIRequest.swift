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
    case getChecklists
    case getWeather(type: WeatherReportType, icao: String)
    case createChatCompletions(parameters: Data?)

    case getUserChecklistsGroups(userId: String)
    case addUserChecklistsGroups(userId: String, checklists: UserChecklistsGroupBase)
    case deleteUserChecklistsGroups(userId: String, groupId: String)

    case deleteAllUserDate(userId: String)
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
        case .getWeather: return URLS.weatherBaseUrl
        case .getChecklists: return URLS.baseMainAPIUrl + "/checklists"
        case .createChatCompletions: return URLS.openaiBaseUrl
        case .deleteAllUserDate(let id): return URLS.baseMainAPIUrl + "/user/\(id)"

        case .getUserChecklistsGroups(let userId): return URLS.baseMainAPIUrl + "/user/\(userId)/checklists_groups"
        case .addUserChecklistsGroups(let userId, _): return URLS.baseMainAPIUrl + "/user/\(userId)/checklists_groups"
        case .deleteUserChecklistsGroups(let userId, let groupId): return URLS.baseMainAPIUrl + "/user/\(userId)/checklists_groups/\(groupId)"
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
        case .addUserChecklistsGroups(_, let checklists): return try? JSONEncoder().encode(checklists)
        default: return nil
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .getAirports, .getRunways, .getFrequencies, .getWeather, .getChecklists, .getUserChecklistsGroups:
            return .get
        case .createChatCompletions, .addUserChecklistsGroups:
            return .post
        case .deleteAllUserDate, .deleteUserChecklistsGroups:
            return .delete
        }
    }

}
