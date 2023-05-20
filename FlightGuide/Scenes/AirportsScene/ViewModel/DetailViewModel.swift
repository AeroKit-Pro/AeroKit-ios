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
    func refresh(withPivotModel model: PivotModel)
}

protocol DetailViewModelOutputs {
    typealias RunwayCellViewModels = [RunwayCellViewModel]
    
    var image: Observable<UIImage>! { get }
    var name: Observable<String>! { get }
    var identifier: Observable<String>! { get }
    var type: Observable<String>! { get }
    var elevation: Observable<String>! { get }
    var municipality: Observable<String>! { get }
    var frequency: Observable<String>! { get }
    var wikipedia: Observable<String>! { get }
    var homeLink: Observable<String>! { get }
    var phoneNumber: Observable<String>! { get }
    var runways: Observable<RunwayCellViewModels>! { get }
}

protocol DetailViewModelType {
    var inputs: DetailViewModelInputs { get }
    var outputs: DetailViewModelOutputs { get }
}

final class DetailViewModel: DetailViewModelInputs, DetailViewModelOutputs, DetailViewModelType {
    
    init() {
        
        self.name = pivotInfo.map { $0.airport.name ?? "no data" }
        self.identifier = pivotInfo.map { $0.airport.ident ?? "no data" }
        self.type = pivotInfo.map { $0.airport.type ?? "no data" }
        self.elevation = pivotInfo.map { $0.airport.elevationFt?.toString() ?? "no data" }
        self.municipality = pivotInfo.map { $0.airport.municipality ?? "no data" }
        self.frequency = pivotInfo.map { $0.frequencies?.first?.frequencyMhz?.toString() ?? "no data" }
        self.wikipedia = pivotInfo.map { $0.airport.wikipediaLink ?? "no data" }
        self.homeLink = pivotInfo.map { $0.airport.homeLink ?? "no data" }
        self.phoneNumber = Observable.just("no data") // dummy string for now
        self.runways = pivotInfo
            .map { $0.runways ?? [] }
            .map { $0.map { RunwayCellViewModel(with: $0) } }
        
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
    var phoneNumber: Observable<String>!
    var runways: Observable<RunwayCellViewModels>!
    
    func refresh(withPivotModel model: PivotModel) {
        pivotInfo.accept(model)
    }
    private let pivotInfo = PublishRelay<PivotModel>()
    
    var inputs: DetailViewModelInputs { self }
    var outputs: DetailViewModelOutputs { self }
    
}
