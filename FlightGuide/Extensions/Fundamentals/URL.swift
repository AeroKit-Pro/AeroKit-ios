//
//  URL.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 21.05.2023.
//

import Foundation

extension URL {
    init?(optionalString: String?) {
        guard let optionalString else { return nil }
        self.init(string: optionalString)
    }
}
