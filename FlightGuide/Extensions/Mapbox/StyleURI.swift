//
//  StyleURI.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 11.07.2023.
//

import MapboxMaps

extension StyleURI {
    init?(url: URL?) {
        guard let url else { return nil }
        self.init(url: url)
    }
}
