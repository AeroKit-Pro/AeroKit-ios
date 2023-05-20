//
//  RunwayCellViewModel.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 20.05.2023.
//

import UIKit

struct RunwayCellViewModel {
    let surface: String
    let length: String
    let width: String
    let lighted: String
    
    init(with runway: Runway) {
        self.surface = runway.surface ?? "no data"
        self.length = runway.lengthFt?.toString() ?? "no data"
        self.width = runway.widthFt?.toString() ?? "no data"
        if let lighted = runway.lighted { self.lighted = lighted ? "Yes" : "No" } else {
            self.lighted = "No data"
        }
    }
}
