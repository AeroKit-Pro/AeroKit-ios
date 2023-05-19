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
    typealias CellViewModels = [AirportCellViewModel]
    typealias PointAnnotations = [PointAnnotation]
    typealias Coordinate = CLLocationCoordinate2D
    typealias RxObservable = RxSwift.Observable
    
    var onSearchStart: RxObservable<Empty>! { get }
    var onSearchEnd: RxObservable<Empty>! { get }
    var searchOutput: RxObservable<CellViewModels>! { get }
    var onItemSelection: RxObservable<Empty>! { get }
    var airportAnnotation: RxObservable<PointAnnotations>! { get }
    var airportCoordinate: RxObservable<Coordinate>! { get }
    var pivotModel: RxObservable<PivotModel>! { get }
    var numberOfActiveFilters: RxObservable<String>! { get }
    var counterBadgeIsHidden: RxObservable<Bool>! { get }
}

protocol AirportsViewModelType {
    var inputs: AirportsViewModelInputs { get }
    var outputs: AirportsViewModelOutputs { get }
}

final class AirportsViewModel: AirportsViewModelType, AirportsViewModelOutputs {

    private let databaseFetcher = DatabaseFetcher()
    private let errorRouter = ErrorRouter()
    private let delegate: AirportsSceneDelegate?
    private let filterInputPassing: FilterInputPassing

    var onSearchStart: RxObservable<Empty>!
    var onSearchEnd: RxObservable<Empty>!
    var searchOutput: RxObservable<CellViewModels>!
    var onItemSelection: RxObservable<Empty>!
    var selectedAirport: RxObservable<Airport>!
    var airportAnnotation: RxObservable<PointAnnotations>!
    var airportCoordinate: RxObservable<Coordinate>!
    var pivotModel: RxObservable<PivotModel>!
    var numberOfActiveFilters: RxObservable<String>!
    var counterBadgeIsHidden: RxObservable<Bool>!

    private let searchInput = PublishRelay<String?>()
    private let searchingBegan = PublishRelay<Empty>()
    private let searchingEnded = PublishRelay<Empty>()
    private let selectedItem = PublishRelay<IndexPath>()
    private let selectedItemPath = PublishRelay<IndexPath>()


    var inputs: AirportsViewModelInputs { self }
    var outputs: AirportsViewModelOutputs { self }

    init(delegate: AirportsSceneDelegate?, filterInputPassing: FilterInputPassing) {
        self.delegate = delegate
        self.filterInputPassing = filterInputPassing
        
        let unwrappedSearchInput = searchInput
            .distinctUntilChanged()
            .skipNil()
            .filter { !$0.isEmpty }
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
        
        let filterSettings = filterInputPassing.filterInput
            .map { AirportFilterSettings(withFilterInput: $0) }
        
        let filteredAirports = RxObservable.combineLatest(unwrappedSearchInput,
                                                          filterSettings) { ($0, $1) }
            .backgroundMap(qos: .userInitiated) { [unowned self] in
                databaseFetcher.fetchPreviewData(AirportPreview.self, input: $0.0, filters: $0.1)
            }
        
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
        
        self.searchOutput = unwrappedFilteredAirports
            .backgroundMap(qos: .userInitiated) { $0.map { AirportCellViewModel(with: $0) } }
                        
        let selectedItemDatabaseId = selectedItemPath.withLatestFrom(unwrappedFilteredAirports) { ($0, $1) }
            .map { indexPath, airports in
                airports[indexPath.row].id
            }
            .share()
        
        let selectedAirport = selectedItemDatabaseId
            .compactMap { self.databaseFetcher.fetchAirport(by: $0)?.first }
            .share()
        
        let selectedRunways = selectedItemDatabaseId
            .map { self.databaseFetcher.fetchRunways(by: $0) }
        
        let selectedFrequencies = selectedItemDatabaseId
            .map { self.databaseFetcher.fetchFrequencies(by: $0) }
        
        self.pivotModel = RxObservable.zip(selectedAirport, selectedRunways, selectedFrequencies) { ($0, $1, $2) }
            .map { PivotModel(airport: $0.0, runways: $0.1, frequencies: $0.2) }
        
        self.onItemSelection = selectedAirport.asEmpty()
        
        self.airportCoordinate = selectedAirport
            .compactMap { Coordinate(lat: $0.latitudeDeg, lon: $0.longitudeDeg) }
        
        self.airportAnnotation = airportCoordinate
            .map { PointAnnotation(coordinate: $0) }
            .map { [$0] }
                        
        self.onSearchStart = searchingBegan.asObservable() // to separate & rename
        self.onSearchEnd = searchingEnded.asObservable() // to separate & rename
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
