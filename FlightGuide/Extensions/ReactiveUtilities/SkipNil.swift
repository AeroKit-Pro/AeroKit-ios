//
//  SkipNil.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 04.04.2023.
//

import RxSwift

extension ObservableType {
    func skipNil<Result>() -> Observable<Result> where Element == Result? {
        self.compactMap { $0 }
    }
}
