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
    let isBookmarkHidden: Bool
    
    init(with previewInfo: AirportPreview) {
        self.title = previewInfo.name ?? "no data"
        self.type = previewInfo.type ?? "no data"
        self.municipality = previewInfo.municipality ?? "no data"
        self.surface = previewInfo.surfaces ?? "no data"
        self.image = UIImage.airport ?? UIImage() // there will be different icons for different types later
        self.isBookmarkHidden = !previewInfo.isFavorite
    }
}
