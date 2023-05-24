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
    func didTapAddToFavoritesButton(_ newValue: Bool)
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
    var runwayModels: Observable<RunwayCellViewModels>! { get }
    var websiteURL: Observable<URL>! { get }
    var metar: Observable<String>! { get }
    var taf: Observable<String>! { get }
    var invalidateWeatherTexts: Observable<String>! { get }
    var runwaysBlockHidden: Observable<Bool>! { get }
    var metarShouldShowActivity: Observable<Bool>! { get }
    var tafShouldShowActivity: Observable<Bool>! { get }
    var isFavorite: Observable<Bool>! { get }
}

protocol DetailViewModelType {
    var inputs: DetailViewModelInputs { get }
    var outputs: DetailViewModelOutputs { get }
}

final class DetailViewModel: DetailViewModelInputs, DetailViewModelOutputs, DetailViewModelType {
    
    private let databaseInteractor = DatabaseInteractor()
    private let apiClient = APIClient()
    
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
    var runwayModels: Observable<RunwayCellViewModels>!
    var websiteURL: Observable<URL>!
    var metar: Observable<String>!
    var taf: Observable<String>!
    var invalidateWeatherTexts: Observable<String>!
    var runwaysBlockHidden: Observable<Bool>!
    var metarShouldShowActivity: Observable<Bool>!
    var tafShouldShowActivity: Observable<Bool>!
    var isFavorite: Observable<Bool>!
    
    private let pivotInfo = PublishRelay<PivotModel>()
    private let homeLinkLabelTapped = PublishRelay<Empty>()
    private let wikipediaLinkLabelTapped = PublishRelay<Empty>()
    private let markAsFavorite = PublishRelay<Bool>()
    
    init() {
        self.name = pivotInfo.map { $0.airport.name ?? "no data" }
        self.identifier = pivotInfo.map { $0.airport.ident ?? "no data" }
        self.type = pivotInfo.map { $0.airport.type ?? "no data" }
        self.elevation = pivotInfo.map { $0.airport.elevationFt?.toString() ?? "no data" }
        self.municipality = pivotInfo.map { $0.airport.municipality ?? "no data" }
        self.frequency = pivotInfo.map { $0.frequencies?.first?.frequencyMhz?.toString() ?? "no data" }
        self.phoneNumber = Observable.just("no data") // dummy string for now
        
        let databaseResponse = markAsFavorite
            .withLatestFrom(pivotInfo) { ($0, $1.airport.id) }
            .map { [unowned self] in databaseInteractor.markAirportAsFavorite($0.0, id: $0.1) }
        let rowUpdateFailed = databaseResponse.filter { !$0 }
        let fallbackValue = rowUpdateFailed
            .withLatestFrom(pivotInfo.map { $0.airport.isFavorite }) { ($1) }
            .compactMap { $0 }
        
        self.isFavorite = Observable.merge(fallbackValue,
                                           pivotInfo.compactMap { $0.airport.isFavorite })
        
        let runways = pivotInfo
            .map { $0.runways ?? [] }
            .share()
        
        self.runwayModels = runways
            .map { $0.map { RunwayCellViewModel(with: $0) } }
        self.runwaysBlockHidden = runways
            .map { $0.isEmpty }
        
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
        
        let icao = pivotInfo.map { $0.airport.ident ?? ""}.share() // TODO: there is almost no nils, but making api call with empty values is not good
        self.invalidateWeatherTexts = icao.map { _ in "" }
        
        let metarReponse = icao
            .flatMap { [unowned self] in
                apiClient.getWeather(type: .metar, icao: $0)
                    .map { $0.data.first }
                    .catchAndReturn("Could not load the data")
            }
            .share()
        let tafReponse = icao
            .flatMap { [unowned self] in
                apiClient.getWeather(type: .taf, icao: $0)
                    .map { $0.data.first }
                    .catchAndReturn("Could not load the data")
            }
            .share()
        let metarIsLoading = Observable
            .merge(icao.map { _ in true }, metarReponse.map { _ in false })
        let tafIsLoading = Observable
            .merge(icao.map { _ in true }, tafReponse.map { _ in false })
            
        self.metarShouldShowActivity = metarIsLoading
        self.tafShouldShowActivity = tafIsLoading
        self.metar = metarReponse.map { $0 ?? "no data" }
        self.taf = tafReponse.map { $0 ?? "no data" }
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
    
    func didTapAddToFavoritesButton(_ newValue: Bool) {
        markAsFavorite.accept(newValue)
    }

    
    var inputs: DetailViewModelInputs { self }
    var outputs: DetailViewModelOutputs { self }
    
}
