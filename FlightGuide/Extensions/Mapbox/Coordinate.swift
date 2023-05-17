//
//  Coordindate.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 17.05.2023.
//

import CoreLocation

extension CLLocationCoordinate2D {
    init?(lat: Double?, lon: Double?) {
        guard let lat, let lon else { return nil }
        self.init(latitude: lat, longitude: lon)
    }
}
