//
//  File.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 04.04.2023.
//

import RxSwift

extension ObservableType {
    func asEmpty() -> Observable<()> {
        self.map { _ in () }
    }
}
