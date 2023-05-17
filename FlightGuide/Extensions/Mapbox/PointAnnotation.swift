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
        image = Image(image: .airport_pin ?? UIImage(), name: "airport_pin")
        iconImage = "airport_pin"
    }
}
