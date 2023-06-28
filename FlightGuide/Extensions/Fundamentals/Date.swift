//
//  Date.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 11.06.2023.
//

import Foundation

extension Date {
    var localisedTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
}
