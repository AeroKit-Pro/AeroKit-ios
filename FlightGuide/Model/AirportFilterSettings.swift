//
//  AirportFilterSettings.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 5.05.23.
//

import Foundation

struct AirportFilterSettings {
    var airportFilterItem: AirportFilterItem = .all
    var minRunwayLength: Int? = nil
    var runwaySurfaces: [String] = []
    var airportTypes: [String] = []
    var isEnabledRunwayLight: Bool = false
    
    var numberOfActiveCriteria: Int {
        countActiveCriteria()
    }
    
    static var empty: AirportFilterSettings {
        AirportFilterSettings()
    }
        
    init(withFilterInput filterInput: FilterInput) {
        airportFilterItem = filterInput.searchItem
        minRunwayLength = filterInput.runwayLength?.numericValue
        runwaySurfaces = filterInput.runwaySurfaces.map { $0.row }
        airportTypes = filterInput.airportTypes.map { $0.row }
        isEnabledRunwayLight = filterInput.lightAvailability
    }
    // used to construct empty settings
    private init() {}
        
    private func countActiveCriteria() -> Int {
        var criteria = 0
        criteria += minRunwayLength == nil ? 0 : 1
        criteria += [runwaySurfaces, airportTypes].reduce(0, { $0 + $1.count })
        criteria += isEnabledRunwayLight ? 1 : 0
        return criteria
    }
}
