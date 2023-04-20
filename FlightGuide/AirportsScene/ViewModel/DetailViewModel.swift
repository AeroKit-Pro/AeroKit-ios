//
//  DetailViewModel.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 09.04.2023.
//

import RxSwift
import RxCocoa
import UIKit

protocol DetailViewModelInputs {
    func refresh(with airport: Airport)
}

protocol DetailViewModelOutputs {
    var image: Observable<UIImage>! { get }
    var name: Observable<String>! { get }
    var identifier: Observable<String>! { get }
    var type: Observable<String>! { get }
    var elevation: Observable<String>! { get }
    var municipality: Observable<String>! { get }
    var frequency: Observable<String>! { get }
    var wikipedia: Observable<String>! { get }
    var homeLink: Observable<String>! { get }
}

protocol DetailViewModelType {
    var inputs: DetailViewModelInputs { get }
    var outputs: DetailViewModelOutputs { get }
}

final class DetailViewModel: DetailViewModelInputs, DetailViewModelOutputs, DetailViewModelType {
    
    init() {
        
        self.name = airportInfo.map { $0.name ?? "No data" }
        self.identifier = airportInfo.map { $0.ident ?? "No data" }
        self.type = airportInfo.map { $0.type ?? "No data" }
        self.elevation = airportInfo.map { $0.elevationFt?.description ?? "No data" }
        self.municipality = airportInfo.map { $0.municipality ?? "No data" }
        //self.frequency = airportInfo.map { $0 }
        //self.wikipedia = airportInfo.map { $0.wikipediaLink ?? "No data" }
        //self.homeLink = airportInfo.map { $0.homeLink ?? "No data" }

        
    }
    
    var image: Observable<UIImage>!
    var name: Observable<String>!
    var identifier: Observable<String>!
    var type: Observable<String>!
    var elevation: Observable<String>!
    var municipality: Observable<String>!
    var frequency: Observable<String>!
    var wikipedia: Observable<String>!
    var homeLink: Observable<String>!
    
    func refresh(with airport: Airport) {
        airportInfo.accept(airport)
    }
    private let airportInfo = PublishRelay<Airport>()
    
    var inputs: DetailViewModelInputs { self }
    var outputs: DetailViewModelOutputs { self }
    
}
