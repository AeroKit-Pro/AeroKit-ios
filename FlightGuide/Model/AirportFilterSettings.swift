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
    let runwaySurface: RunwaySurface?
    let airportType: AirportType?
    let isEnabledRunwayLight: Bool
}
