//
//  String.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 02.04.2023.
//

import Foundation

extension String {
    func localized() -> String {
        NSLocalizedString(self, comment: "")
    }
}

extension String {
    var numericValue: Int? {
        Int(self)
    }
}
