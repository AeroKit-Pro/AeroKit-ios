//
//  AirportCellViewModel.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 07.04.2023.
//

import UIKit

struct AirportCellViewModel {
    let image: UIImage
    let title: String
    let type: String
    let municipality: String
    let surface: String
    
    init(with airport: Airport) {
        self.title = airport.name ?? "?"
        self.type = airport.type ?? "?"
        self.municipality = airport.municipality ?? "?"
        self.surface = "no data" // ИЗМЕНИТЬ
        self.image = UIImage.airport ?? UIImage()// ИЗМЕНИТЬ
    }
}
