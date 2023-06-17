//
//  PointAnnotation.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 09.04.2023.
//

import MapboxMaps

extension PointAnnotation {
    init?(location: CLLocationCoordinate2D?, airportId id: String = UUID().uuidString) {
        guard let location else { return nil }  
        
        self.init(id: id, point: Point(location))
        image = Image(image: .airport_pin ?? UIImage(), name: "airport_pin")
        iconImage = "airport_pin"
    }
}

extension PointAnnotation {
    var airportId: Int? {
        id.numericValue
    }
}
