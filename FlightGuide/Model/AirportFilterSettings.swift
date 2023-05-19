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
    
    var numberOfActiveCriteria: Int {
        countActiveCriteria()
    }
    
    init?(withFilterInput filterInput: FilterInput?) {
        guard let filterInput else { return nil }
        
        airportFilterItem = filterInput.searchItem
        minRunwayLength = filterInput.runwayLength?.numericValue
        runwaySurfaces = filterInput.runwaySurfaces.map { $0.row }
        airportTypes = filterInput.airportTypes.map { $0.row }
        isEnabledRunwayLight = filterInput.lightAvailability
    }
    
    private func countActiveCriteria() -> Int {
        var criteria = 0
        criteria += minRunwayLength == nil ? 0 : 1
        criteria += [runwaySurfaces, airportTypes].reduce(0, { $0 + $1.count })
        criteria += isEnabledRunwayLight ? 1 : 0
        return criteria
    }
}
