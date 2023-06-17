//
//  CityCellViewModel.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 31.05.2023.
//

import UIKit

struct CityCellViewModel {
    typealias AirportsGroupedByCity = [String? : [AirportByCity]]
    
    var typeCountStrings: [String]
    let name: String?
    
    init(with element: AirportsGroupedByCity.Element) {
        name = element.key
        typeCountStrings = []
        let countByTypes = Dictionary(grouping: element.value, by: { $0.type })
            .mapValues { $0.count }
            .sorted { $0.value > $1.value }
        countByTypes.forEach { type, count in
            if let type {
                typeCountStrings.append("\(type) : \(count)")
            }
        }
    }
}
