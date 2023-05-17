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

protocol AirportsViewModelInputs {
    func searchInputDidChange(text: String?)
    func didBeginSearching()
    func didEndSearching()
    func didSelectItem(at indexPath: IndexPath)
    func didTapApplyFiltersButton()
    func didCollectFilterInput(filterInput input: FilterInput)
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
    var dismissFilterScene: RxObservable<Empty>! { get }
    var collectFilters: RxObservable<Empty>! { get }
    var pivotModel: RxObservable<PivotModel>! { get }
}

protocol AirportsViewModelType {
    var inputs: AirportsViewModelInputs { get }
    var outputs: AirportsViewModelOutputs { get }
}

final class AirportsViewModel: AirportsViewModelType, AirportsViewModelInputs, AirportsViewModelOutputs {
    
    private let databaseFetcher = DatabaseFetcher()
    private let errorRouter = ErrorRouter()
    
    init() {
        let unwrappedSearchInput = searchInput
            .skipNil()
            .filter { !$0.isEmpty }
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
        
        let filterSettings = filterInput
            .map { AirportFilterSettings(withFilterInput: $0) }
            .startWith(nil)
        
        let filteredAirports = RxObservable.combineLatest(unwrappedSearchInput,
                                                          filterSettings) { ($0, $1) }
            .backgroundMap(qos: .userInitiated) { [unowned self] in
                databaseFetcher.fetchPreviewData(AirportPreview.self, input: $0.0, filters: $0.1)
            }
            .share()
        
        let unwrappedFilteredAirports = filteredAirports.backgroundCompactMap(qos: .userInitiated) { $0 }
        
        self.searchOutput = unwrappedFilteredAirports
            .backgroundMap(qos: .userInitiated) { $0.map { AirportCellViewModel(with: $0) } }
        
        self.dismissFilterScene = applyFiltersButtonTapped.asObservable()
        
        self.collectFilters = applyFiltersButtonTapped.asObservable()
        
        let selectedItemDatabaseId = selectedItemPath.withLatestFrom(unwrappedFilteredAirports) { ($0, $1) }
            .map { indexPath, airports in
                airports[indexPath.row].id
            }
            .share()
        
        let selectedAirport = selectedItemDatabaseId
            .compactMap { self.databaseFetcher.fetchAirport(by: $0)?.first }
        
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

    var onSearchStart: RxObservable<Empty>!
    var onSearchEnd: RxObservable<Empty>!
    var searchOutput: RxObservable<CellViewModels>!
    var onItemSelection: RxObservable<Empty>!
    var airportAnnotation: RxObservable<PointAnnotations>!
    var airportCoordinate: RxObservable<Coordinate>!
    var dismissFilterScene: RxObservable<Empty>!
    var collectFilters: RxObservable<Empty>!
    var pivotModel: RxObservable<PivotModel>!
    
    func searchInputDidChange(text: String?) {
        searchInput.accept(text)
    }
    private let searchInput = PublishRelay<String?>()
    
    func didBeginSearching() {
        searchingBegan.accept(Empty())
    }
    private let searchingBegan = PublishRelay<Empty>()
    
    func didEndSearching() {
        searchingEnded.accept(Empty())
    }
    private let searchingEnded = PublishRelay<Empty>()
    
    func didSelectItem(at indexPath: IndexPath) {
        selectedItemPath.accept(indexPath)
    }
    private let selectedItemPath = PublishRelay<IndexPath>()
    
    func didTapApplyFiltersButton() {
        applyFiltersButtonTapped.accept(Empty())
    }
    private let applyFiltersButtonTapped = PublishRelay<Empty>()
    
    func didCollectFilterInput(filterInput input: FilterInput) {
        filterInput.accept(input)
    }
    private let filterInput = PublishRelay<FilterInput>()
    
    var inputs: AirportsViewModelInputs { self }
    var outputs: AirportsViewModelOutputs { self }
    
}
