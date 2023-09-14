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

extension CLLocationCoordinate2D: Decodable {
    enum CodingKeys: String, CodingKey {
        case latitude = "latitude_deg"
        case longitude = "longitude_deg"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }
}

