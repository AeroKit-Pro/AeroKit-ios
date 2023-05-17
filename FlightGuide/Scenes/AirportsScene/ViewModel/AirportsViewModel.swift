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
    func didTapFilter()
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
    var selectedAirport: RxObservable<Airport>! { get }
    var airportAnnotation: RxObservable<PointAnnotations>! { get }
    var airportCoordinate: RxObservable<Coordinate>! { get }
}

protocol AirportsViewModelType {
    var inputs: AirportsViewModelInputs { get }
    var outputs: AirportsViewModelOutputs { get }
}

final class AirportsViewModel: AirportsViewModelType, AirportsViewModelOutputs {

    private let databaseFetcher = DatabaseFetcher()
    private let errorRouter = ErrorRouter()
    private let delegate: AirportsSceneDelegate?

    var onSearchStart: RxObservable<Empty>!
    var onSearchEnd: RxObservable<Empty>!
    var searchOutput: RxObservable<CellViewModels>!
    var onItemSelection: RxObservable<Empty>!
    var selectedAirport: RxObservable<Airport>!
    var airportAnnotation: RxObservable<PointAnnotations>!
    var airportCoordinate: RxObservable<Coordinate>!

    private let searchInput = PublishRelay<String?>()
    private let searchingBegan = PublishRelay<Empty>()
    private let searchingEnded = PublishRelay<Empty>()
    private let selectedItem = PublishRelay<IndexPath>()

    var inputs: AirportsViewModelInputs { self }
    var outputs: AirportsViewModelOutputs { self }

    init(delegate: AirportsSceneDelegate?) {
        self.delegate = delegate
        let unwrappedSearchInput = searchInput
            .skipNil()
            .filter { !$0.isEmpty }
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
        
        let filteredAirports = unwrappedSearchInput
            .backgroundCompactMap(qos: .userInteractive) { [unowned self] in
                self.databaseFetcher.fetchPreviewData(AirportPreview.self, filter: $0) }
            .share()
        
        self.searchOutput = filteredAirports
            .backgroundMap(qos: .userInteractive) { $0.map { AirportCellViewModel(with: $0) } }
        /*
        self.onItemSelection = selectedItem.asEmpty()
        
        let selectedAirport = selectedItem.withLatestFrom(filteredAirports) { ($0, $1) }
            .map { index, airports in
                airports[index.row]
            }
        
        self.airportCoordinate = selectedAirport
            .map { _ in Coordinate() } // mock coordinate for now
            .share()
        
        self.airportAnnotation = airportCoordinate
            .map { PointAnnotation(coordinate: $0) }
            .map { [$0] }
        
        self.selectedAirport = selectedAirport
        */
        self.onSearchStart = searchingBegan.asObservable()
        self.onSearchEnd = searchingEnded.asObservable()
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
        selectedItem.accept(indexPath)
    }

    func didTapFilter() {
        delegate?.openFilters()
    }
}
