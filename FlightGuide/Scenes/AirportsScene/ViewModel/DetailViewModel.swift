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

final class DetailViewModel: DetailViewModelOutputs, DetailViewModelType {
    
    private let databaseInteractor = DatabaseInteractor()
    private let apiClient = APIClient()
    @UserDataStorage(key: UserDefaultsKey.savedIdObjectWithDate)
    private var savedFavorites: [IdObjectWithDate]?
    
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
        self.type = pivotInfo.map { $0.airport.type?.replacingOccurrences(of: "_", with: " ") ?? "no data" }
        self.elevation = pivotInfo.map { $0.airport.elevationFt?.toString() ?? "no data" }
        self.municipality = pivotInfo.map { $0.airport.municipality ?? "no data" }
        self.frequency = pivotInfo.map { $0.frequencies?.first?.frequencyMhz?.toString() ?? "no data" }
        self.phoneNumber = Observable.just("no data") // dummy string for now
        
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
        
        let icao = pivotInfo
            .map { $0.airport.ident}
            .share()
        
        let addToFavorite = markAsFavorite.withLatestFrom(pivotInfo) { ($0, $1) }
            .map { [unowned self] in
                manageFavoriteStatus(for: $0.1.airport.id, newStatus: $0.0)
            }
        
        self.isFavorite = Observable.merge(
            pivotInfo
                .map { [unowned self] model in
                    guard let savedFavorites else { return false }
                    return savedFavorites.contains(where: { $0.id == model.airport.id })
                },
            addToFavorite
        )
        
        self.invalidateWeatherTexts = icao.map { _ in "" }
        
        let metarResponse = icao
            .compactMap { $0 }
            .flatMap { [unowned self] in
                apiClient.getWeather(type: .metar, icao: $0)
                    .map { $0.data.first }
                    .catchAndReturn("Could not load the data")
            }
            .share()
        
        let tafResponse = icao
            .compactMap { $0 }
            .flatMap { [unowned self] in
                apiClient.getWeather(type: .taf, icao: $0)
                    .map { $0.data.first }
                    .catchAndReturn("Could not load the data")
            }
            .share()
        let metarIsLoading = Observable
            .merge(icao.map { _ in true }, metarResponse.map { _ in false })
        let tafIsLoading = Observable
            .merge(icao.map { _ in true }, tafResponse.map { _ in false })
            
        self.metarShouldShowActivity = metarIsLoading
        self.tafShouldShowActivity = tafIsLoading
        self.metar = metarResponse.map { $0 ?? "no data" }
        self.taf = tafResponse.map { $0 ?? "no data" }
    }
    
    var inputs: DetailViewModelInputs { self }
    var outputs: DetailViewModelOutputs { self }
    
    private func manageFavoriteStatus(for id: Int, newStatus: Bool) -> Bool {
        if var savedFavorites = savedFavorites {
            newStatus ? savedFavorites.append(IdObjectWithDate(id: id, date: Date())) : savedFavorites.removeAll { $0.id == id }
            self.savedFavorites = savedFavorites
            return savedFavorites.contains { $0.id == id }
        }
        if newStatus {
            savedFavorites = [IdObjectWithDate(id: id, date: Date())]
            return true
        }
        
        return false
    }
    
}

extension DetailViewModel: DetailViewModelInputs {
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
}
