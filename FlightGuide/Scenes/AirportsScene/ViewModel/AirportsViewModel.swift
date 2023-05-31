//
//  ViewModel.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 29.03.2023.
//

import RxSwift
import RxCocoa
import Foundation
import MapboxMaps

protocol AirportsSceneDelegate: Coordinatable {
    func openFilters()
}

protocol AirportsViewModelInputs {
    func searchInputDidChange(text: String?)
    func didBeginSearching()
    func didEndSearching()
    func didSelectItem(at indexPath: IndexPath)
    func didTapFiltersButton()
}

protocol AirportsViewModelOutputs {
    typealias Empty = ()
    typealias Airports = [Airport]
    typealias SectionModels = [SectionedTableModel]
    typealias PointAnnotations = [PointAnnotation]
    typealias Coordinate = CLLocationCoordinate2D
    typealias RxObservable = RxSwift.Observable
    typealias AirportsGroupedByCities = [String? : [AirportByCity]]
    
    var onSearchStart: RxObservable<Empty>! { get }
    var onSearchEnd: RxObservable<Empty>! { get }
    var searchOutput: RxObservable<SectionModels>! { get }
    var onItemSelection: RxObservable<Empty>! { get }
    var airportAnnotation: RxObservable<PointAnnotations>! { get }
    var airportCoordinate: RxObservable<Coordinate>! { get }
    var pivotModel: RxObservable<PivotModel>! { get }
    var numberOfActiveFilters: RxObservable<String>! { get }
    var counterBadgeIsHidden: RxObservable<Bool>! { get }
    var dismissDetailView: RxObservable<Empty>! { get }
    var searchFieldCanDismiss: RxObservable<Empty>! { get }
}

protocol AirportsViewModelType {
    var inputs: AirportsViewModelInputs { get }
    var outputs: AirportsViewModelOutputs { get }
}

final class AirportsViewModel: AirportsViewModelType, AirportsViewModelOutputs {
    //MARK: - Services
    private let databaseInteractor = DatabaseInteractor()
    private let errorRouter = ErrorRouter()
    private let delegate: AirportsSceneDelegate?
    private let filterInputPassing: FilterInputPassing
    private let notificationCenter: NotificationCenterModuleInterface
    private var notificationTokens: [NotificationToken] = []
    // MARK: - AirportsViewModelOutputs
    var onSearchStart: RxObservable<Empty>!
    var onSearchEnd: RxObservable<Empty>!
    var searchOutput: RxObservable<SectionModels>!
    var onItemSelection: RxObservable<Empty>!
    var selectedAirport: RxObservable<Airport>!
    var airportAnnotation: RxObservable<PointAnnotations>!
    var airportCoordinate: RxObservable<Coordinate>!
    var pivotModel: RxObservable<PivotModel>!
    var numberOfActiveFilters: RxObservable<String>!
    var counterBadgeIsHidden: RxObservable<Bool>!
    var dismissDetailView: RxObservable<Empty>!
    var searchFieldCanDismiss: RxObservable<Empty>!
    //MARK: - Values
    private let searchInput = PublishRelay<String?>()
    private let searchingBegan = PublishRelay<Empty>()
    private let searchingEnded = PublishRelay<Empty>()
    private let selectedItem = PublishRelay<IndexPath>()
    private let selectedItemPath = PublishRelay<IndexPath>()
    private let favoriteAirportId = PublishRelay<Int>()
    
    var inputs: AirportsViewModelInputs { self }
    var outputs: AirportsViewModelOutputs { self }
    
    init(delegate: AirportsSceneDelegate?,
         filterInputPassing: FilterInputPassing,
         notificationCenter: NotificationCenterModuleInterface) {
        self.delegate = delegate
        self.filterInputPassing = filterInputPassing
        self.notificationCenter = notificationCenter
        
        let unwrappedSearchInput = searchInput
            .distinctUntilChanged()
            .skipNil()
            .filter { $0.count > 1 }
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
        
        let filterSettings = filterInputPassing.filterInput
            .map { AirportFilterSettings(withFilterInput: $0) }
                
        let filteredAirports = RxObservable.combineLatest(unwrappedSearchInput,
                                                          filterSettings) { ($0, $1) }
            .backgroundMap(qos: .userInitiated) { [unowned self] in
                databaseInteractor.fetchPreviewData(AirportPreview.self, input: $0.0, filters: $0.1)
            }
        
        let airportsByCity = RxObservable
            .combineLatest(unwrappedSearchInput, filterSettings) { ($0, $1) }
            .backgroundCompactMap(qos: .userInitiated) { [unowned self] in
                databaseInteractor.fetchAirportsByCity(AirportByCity.self, input: $0.0, filters: $0.1)
            }
            .map { Dictionary(grouping: $0, by: { $0.municipality }) }
            .map { $0.sorted { $0.value.count > $1.value.count } }
                
        let numberOfActiveCriteria = filterSettings
            .skipNil()
            .map { $0.numberOfActiveCriteria }
            .share()
        
        self.numberOfActiveFilters = numberOfActiveCriteria
            .map { $0.toString() }
        
        self.counterBadgeIsHidden = numberOfActiveCriteria
            .map { $0 <= 0 }
            .startWith(true)
        
        let unwrappedFilteredAirports = filteredAirports
            .backgroundCompactMap(qos: .userInitiated) { $0 }
            .share()
        
        let cityCellViewModels = airportsByCity
            .backgroundMap(qos: .userInitiated) { $0.map { CityCellViewModel(with: $0) } }
        
        let airportCellViewModels = unwrappedFilteredAirports
            .backgroundMap(qos: .userInitiated) { $0.map { AirportCellViewModel(with: $0) } }
        
        let citiesSection = cityCellViewModels
            .map { $0.map { SectionItem.cityItem(viewModel: $0) } }
            .map { SectionedTableModel.citiesSection(title: $0.isEmpty ? "" : "Cities - \($0.count)",
                                                     items: $0) }
        
        let airportsSection = airportCellViewModels
            .map { $0.map { SectionItem.airportItem(viewModel: $0) } }
            .map { SectionedTableModel.airportsSection(title: $0.isEmpty ? "" : "Airports - \($0.count)",
                                                       items: $0) }
        
        self.searchOutput = RxObservable.zip(citiesSection, airportsSection).map { [$0.0, $0.1] }

        let selectedItemDatabaseId = selectedItemPath.withLatestFrom(unwrappedFilteredAirports) { ($0, $1) }
            .map { indexPath, airports in
                airports[indexPath.row].id
            }
            .share()
        
        let selectedAirport = RxObservable
            .merge(selectedItemDatabaseId, favoriteAirportId.asObservable())
            .compactMap { self.databaseInteractor.fetchAirport(by: $0)?.first }
            .share()
        
        let selectedRunways = RxObservable
            .merge(selectedItemDatabaseId, favoriteAirportId.asObservable())
            .map { self.databaseInteractor.fetchRunways(by: $0) }
        
        let selectedFrequencies = RxObservable
            .merge(selectedItemDatabaseId, favoriteAirportId.asObservable())
            .map { self.databaseInteractor.fetchFrequencies(by: $0) }
        
        self.pivotModel = RxObservable
            .zip(selectedAirport, selectedRunways, selectedFrequencies) { ($0, $1, $2) }
            .map { PivotModel(airport: $0.0, runways: $0.1, frequencies: $0.2) }
        
        self.onItemSelection = selectedAirport.asEmpty()
        
        self.dismissDetailView = searchingEnded.asObservable()
        
        self.airportCoordinate = selectedAirport
            .compactMap { Coordinate(lat: $0.latitudeDeg, lon: $0.longitudeDeg) }
        
        self.airportAnnotation = airportCoordinate
            .map { PointAnnotation(coordinate: $0) }
            .map { [$0] }
        
        self.onSearchStart = searchingBegan.asObservable() // to separate & rename
        self.onSearchEnd = searchingEnded.asObservable() // to separate & rename
        self.searchFieldCanDismiss = favoriteAirportId.asEmpty()
        
        subscribeOnNotifications()
    }
        
    private func subscribeOnNotifications() {
        notificationTokens.append(
            notificationCenter.observe(
                name: .didSelectFavouriteAirport
            ) { [weak self] notification in
                guard let self = self,
                      let id = notification.object as? Int else {
                    return
                }
                self.favoriteAirportId.accept(id)
            }
        )
    }
}

// MARK: - AirportsViewModelInputs
extension AirportsViewModel: AirportsViewModelInputs {
    func searchInputDidChange(text: String?) {
        searchInput.accept(text)
    }
    
    func didBeginSearching() {
        searchingBegan.accept(Empty())
    }
    
    func didEndSearching() {
        searchingEnded.accept(Empty())
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        selectedItemPath.accept(indexPath)
    }
    
    func didTapFiltersButton() {
        delegate?.openFilters()
    }
}
