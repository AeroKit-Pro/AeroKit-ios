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
    func didTapOnHomeLinkLabel()
    func didTapOnWikipediaLinkLabel()
}

protocol DetailViewModelOutputs {
    typealias RunwayCellViewModels = [RunwayCellViewModel]
    typealias Empty = ()
    
    var image: Observable<UIImage>! { get }
    var name: Observable<String>! { get }
    var identifier: Observable<String>! { get }
    var type: Observable<String>! { get }
    var elevation: Observable<String>! { get }
    var municipality: Observable<String>! { get }
    var frequency: Observable<String>! { get }
    var wikipedia: Observable<NSAttributedString>! { get }
    var homeLink: Observable<NSAttributedString>! { get }
    var phoneNumber: Observable<String>! { get }
    var runways: Observable<RunwayCellViewModels>! { get }
    var websiteURL: Observable<URL>! { get }
}

protocol DetailViewModelType {
    var inputs: DetailViewModelInputs { get }
    var outputs: DetailViewModelOutputs { get }
}

final class DetailViewModel: DetailViewModelInputs, DetailViewModelOutputs, DetailViewModelType {
    
    var image: Observable<UIImage>!
    var name: Observable<String>!
    var identifier: Observable<String>!
    var type: Observable<String>!
    var elevation: Observable<String>!
    var municipality: Observable<String>!
    var frequency: Observable<String>!
    var wikipedia: Observable<NSAttributedString>!
    var homeLink: Observable<NSAttributedString>!
    var phoneNumber: Observable<String>!
    var runways: Observable<RunwayCellViewModels>!
    var websiteURL: Observable<URL>!
    
    private let pivotInfo = PublishRelay<PivotModel>()
    private let homeLinkLabelTapped = PublishRelay<Empty>()
    private let wikipediaLinkLabelTapped = PublishRelay<Empty>()
    
    init() {
        
        self.name = pivotInfo.map { $0.airport.name ?? "no data" }
        self.identifier = pivotInfo.map { $0.airport.ident ?? "no data" }
        self.type = pivotInfo.map { $0.airport.type ?? "no data" }
        self.elevation = pivotInfo.map { $0.airport.elevationFt?.toString() ?? "no data" }
        self.municipality = pivotInfo.map { $0.airport.municipality ?? "no data" }
        self.frequency = pivotInfo.map { $0.frequencies?.first?.frequencyMhz?.toString() ?? "no data" }
        self.phoneNumber = Observable.just("no data") // dummy string for now
        
        self.runways = pivotInfo
            .map { $0.runways ?? [] }
            .map { $0.map { RunwayCellViewModel(with: $0) } }
        
        let homeLinkURL = pivotInfo.map { URL(optionalString: $0.airport.homeLink) }.share()
        let wikipediaLinkURL = pivotInfo.map { URL(optionalString: $0.airport.wikipediaLink) }.share()

        self.homeLink = homeLinkURL
            .map { $0 == nil ? NSAttributedString(string: "no data") :
                NSAttributedString(string: "go to website",
                                   attributes: [.underlineStyle : NSUnderlineStyle.single.rawValue]) }
        self.wikipedia = wikipediaLinkURL // TODO: Attributed string to be contained in single observable
            .map { $0 == nil ? NSAttributedString(string: "no data") :
                NSAttributedString(string: "go to website",
                                   attributes: [.underlineStyle : NSUnderlineStyle.single.rawValue]) }
        let linkTapEvent = Observable
            .merge(homeLinkLabelTapped.withLatestFrom(homeLinkURL.skipNil()),
                   wikipediaLinkLabelTapped.withLatestFrom(wikipediaLinkURL.skipNil()))
        self.websiteURL = linkTapEvent
    }
    
    func refresh(withPivotModel model: PivotModel) {
        pivotInfo.accept(model)
    }
    
    func didTapOnHomeLinkLabel() {
        homeLinkLabelTapped.accept(Empty())
    }
    
    func didTapOnWikipediaLinkLabel() {
        wikipediaLinkLabelTapped.accept(Empty())
    }
    
    var inputs: DetailViewModelInputs { self }
    var outputs: DetailViewModelOutputs { self }
    
}
