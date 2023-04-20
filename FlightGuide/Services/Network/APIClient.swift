//
//  APIService.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 30.03.2023.
//

import Alamofire
import RxSwift
import Foundation

protocol APIClientProtocol {
    associatedtype RequestedType
    func getAirports() -> Observable<RequestedType>
}

final class APIClient: APIClientProtocol {

    func getAirports() -> Observable<Airports> {
        request(APIRequest.getAirports)
    }
    
    func getRunways() -> Observable<Runways> {
        request(APIRequest.getRunways)
    }
    
    func getFrequencies() -> Observable<Frequencies> {
        request(APIRequest.getFrequencies)
    }
    
    func getCities() -> Observable<Citites> {
        request(APIRequest.getCities)
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
