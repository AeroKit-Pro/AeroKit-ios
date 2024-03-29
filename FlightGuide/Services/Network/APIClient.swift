//
//  APIService.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 30.03.2023.
//

import Alamofire
import RxSwift
import Foundation

final class APIClient {

    func getAirports() -> Observable<Airports> {
        request(APIRequest.getAirports)
    }
    
    func getRunways() -> Observable<Runways> {
        request(APIRequest.getRunways)
    }
    
    func getFrequencies() -> Observable<Frequencies> {
        request(APIRequest.getFrequencies)
    }
    
    func getWeather(type: WeatherReportType, icao: String) -> Observable<Weather> {
        request(APIRequest.getWeather(type: type, icao: icao))
    }

    func getChecklists() -> Observable<[CompanyWithPlanesModel]> {
        request(APIRequest.getChecklists)
    }

    func getUserChecklistsGroups(userId: String) -> Observable<UserChecklistsGroups> {
        request(APIRequest.getUserChecklistsGroups(userId: userId))
    }

    func addUserChecklistsGroups(userId: String, checklists: UserChecklistsGroupBase) -> Observable<Empty> {
        request(APIRequest.addUserChecklistsGroups(userId: userId, checklists: checklists))
    }

    func deleteUserChecklistsGroups(userId: String, groupId: String) -> Observable<Empty> {
        request(APIRequest.deleteUserChecklistsGroups(userId: userId, groupId: groupId))
    }

    func deleteAllUserData(userId: String) -> Observable<Empty> {
        request(APIRequest.deleteAllUserDate(userId: userId))
    }
    
    func createStreamChatCompletion(parameters: Data?) -> DataStreamRequest {
        AF.streamRequest(APIRequest.createChatCompletions(parameters: parameters))
    }

    private func request<T: Codable> (_ apiRequest: URLRequestConvertible) -> Observable<T> {
        return Observable<T>.create { observer in
            let request = AF.request(apiRequest).responseDecodable { (response: DataResponse<T, AFError>) in
                switch response.result {
                case .success(let result):
                        observer.onNext(result)
                        observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }

}
