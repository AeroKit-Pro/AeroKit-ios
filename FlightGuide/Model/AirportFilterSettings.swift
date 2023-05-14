//
//  AirportFilterSettings.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 5.05.23.
//

import Foundation

struct AirportFilterSettings {
    let airportFilterItem: AirportFilterItem
    let minRunwayLength: Int?
    let runwaySurfaces: [String]
    let airportTypes: [String]
    let isEnabledRunwayLight: Bool
    
    init(withFilterInput filterInput: FilterInput) {
        airportFilterItem = filterInput.searchItem
        minRunwayLength = filterInput.runwayLength?.numericValue
        runwaySurfaces = filterInput.runwaySurfaces.map { $0.row }
        airportTypes = filterInput.airportTypes.map { $0.row }
        isEnabledRunwayLight = filterInput.lightAvailability
    }
}
