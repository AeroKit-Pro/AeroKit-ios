//
//  CoordinateBounds.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 04.06.2023.
//

import MapboxMaps

extension CoordinateBounds {
    convenience init?(maxYminX: CLLocationCoordinate2D?, minYmaxX: CLLocationCoordinate2D?) {
        guard let southwest = maxYminX, let northeast = minYmaxX else { return nil }
        self.init(southwest: southwest, northeast: northeast)
    }
}
