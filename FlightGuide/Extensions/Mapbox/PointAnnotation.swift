//
//  PointAnnotation.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 09.04.2023.
//

import MapboxMaps

extension PointAnnotation {
    init(coordinate: CLLocationCoordinate2D) {
        self.init(point: Point(coordinate))
        image = .init(image: .pin ?? UIImage(), name: "red_pin")
        iconImage = "red_pin"
    }
}
