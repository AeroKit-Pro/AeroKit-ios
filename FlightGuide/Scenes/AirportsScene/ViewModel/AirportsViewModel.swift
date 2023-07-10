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
    func didSelectPointAnnotation(_ annotation: PointAnnotation)
    func didTapFiltersButton()
}

protocol AirportsViewModelOutputs {
    typealias Empty = ()
    typealias Airports = [Airport]
    typealias SectionModels = [SectionedTableModel]
    typealias PointAnnotations = [PointAnnotation]
    typealias Coordinate = CLLocationCoordinate2D
    typealias RxObservable = RxSwift.Observable
    
    var onSearchStart: RxObservable<Empty>! { get }
    var onSearchEnd: RxObservable<Empty>! { get }
    var searchOutput: RxObservable<SectionModels>! { get }
    var onCitySelection: RxObservable<Empty>! { get }
    var onAirportSelection: RxObservable<Empty>! { get }
    var pointAnnotations: RxObservable<PointAnnotations>! { get }
    var boundingBox: RxObservable<CoordinateBounds>! { get }
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
    // MARK: - AirportsViewModelOutputs
    var onSearchStart: RxObservable<Empty>!
    var onSearchEnd: RxObservable<Empty>!
    var searchOutput: RxObservable<SectionModels>!
    var onCitySelection: RxObservable<Empty>!
    var onAirportSelection: RxObservable<Empty>!
    var selectedAirport: RxObservable<Airport>!
    var pointAnnotations: RxObservable<PointAnnotations>!
    var boundingBox: RxObservable<CoordinateBounds>!
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
    private let selectedPointAnnotation = PublishRelay<PointAnnotation>()
    private let selectedItemPath = PublishRelay<IndexPath>()
    private let favoriteAirportId = PublishRelay<Int>()
    //MARK: - Services
    private let databaseInteractor = DatabaseInteractor()
    private let errorRouter = ErrorRouter()
    private let delegate: AirportsSceneDelegate?
    private let filterInputPassing: FilterInputPassing
    private let notificationCenter: NotificationCenterModuleInterface
    private var notificationTokens: [NotificationToken] = []
    // MARK: - States
    private var onCityPresentation = false
    
    var inputs: AirportsViewModelInputs { self }
    var outputs: AirportsViewModelOutputs { self }
    
    init(delegate: AirportsSceneDelegate?,
         filterInputPassing: FilterInputPassing,
         notificationCenter: NotificationCenterModuleInterface) {
        self.delegate = delegate
        self.filterInputPassing = filterInputPassing
        self.notificationCenter = notificationCenter
        
        let filterInput = filterInputPassing.filterInput
        
        let unwrappedSearchInput = searchInput
            .distinctUntilChanged()
            .skipNil()
            .filter { $0.count > 1 }
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .share()
        // TODO: replayed multiple times
        let filterSettings = filterInput
            .map { AirportFilterSettings(withFilterInput: $0) }
            .share()
            .startWith(AirportFilterSettings.empty)

        let airportsByCity = RxObservable
            .combineLatest(unwrappedSearchInput, filterSettings) { ($0, $1) }
            .filter { $0.1.airportFilterItem != .airports  }
            .backgroundCompactMap(qos: .userInitiated) { [unowned self] in
                databaseInteractor.fetchAirportsByCity(AirportByCity.self, input: $0.0, filters: $0.1)
            }
            .map { Dictionary(grouping: $0, by: { $0.municipality }) }
            .map { $0.sorted { $0.value.count > $1.value.count } }
            .startWith([])
            .share()
        
        let filteredAirports = RxObservable
            .combineLatest(unwrappedSearchInput, filterSettings) { ($0, $1) }
            .filter { $0.1.airportFilterItem != .cities  }
            .backgroundMap(qos: .userInitiated) { [unowned self] in
                databaseInteractor.fetchPreviewData(AirportPreview.self, input: $0.0, filters: $0.1)
            }
            .startWith([])
            .share()

        let numberOfActiveCriteria = filterSettings
            .map { $0.numberOfActiveCriteria }
            .share()
        
        self.numberOfActiveFilters = numberOfActiveCriteria
            .map { $0.toString() }
        
        self.counterBadgeIsHidden = numberOfActiveCriteria
            .map { $0 <= 0 }
        
        let unwrappedFilteredAirports = filteredAirports
            .backgroundCompactMap(qos: .userInitiated) { $0 }
            .share()
            .startWith([])
            .share()

        let cityCellViewModels = airportsByCity
            .backgroundMap(qos: .userInitiated) { $0.map { CityCellViewModel(with: $0) } }
            .share()
                
        let airportCellViewModels = unwrappedFilteredAirports
            .backgroundMap(qos: .userInitiated) { $0.map { AirportCellViewModel(with: $0) } }
            .share()
                
        let citiesSection = cityCellViewModels
            .map { $0.map { SectionItem.cityItem(viewModel: $0) } }
            .map { SectionedTableModel.citiesSection(title: $0.isEmpty ? "" : "Cities - \($0.count)",
                                                     items: $0) }
        
        let airportsSection = airportCellViewModels
            .map { $0.map { SectionItem.airportItem(viewModel: $0) } }
            .map { SectionedTableModel.airportsSection(title: $0.isEmpty ? "" : "Airports - \($0.count)",
                                                       items: $0) }
        
        self.searchOutput = RxObservable.combineLatest(citiesSection, airportsSection, filterSettings)
            .map { citiesSection, airportsSection, filterSettings in
                switch filterSettings.airportFilterItem {
                case .airports:
                    return [SectionedTableModel.citiesSection(title: "", items: []), airportsSection]
                case .cities:
                    return [citiesSection, SectionedTableModel.airportsSection(title: "", items: [])]
                case .all:
                    return [citiesSection, airportsSection]
                }
            }
        
        let models = RxObservable
            .combineLatest(airportsByCity, unwrappedFilteredAirports)
            .map { [$0.0, $0.1] as [[Any]] }
            .share()
        
        let selectedModel = selectedItemPath
            .withLatestFrom(models) { ($0, $1) }
            .map { indexPath, models in
                let section = models[indexPath.section]
                return section[indexPath.row]
            }
            .do(onNext: { self.onCityPresentation = $0 is (key: Optional<String>, value: Array<AirportByCity>) })
            .share()
        
        let selectedItemDatabaseId = RxObservable
                .merge(selectedModel
                .compactMap { $0 as? AirportPreview }
                .map { $0.id },
            selectedPointAnnotation
                .compactMap { $0.airportId })
            .share()
        
        let selectedCityAirports = selectedModel
            .compactMap { return $0 as? (key: Optional<String>, value: Array<AirportByCity>) }
            .map { $0.value }
            .share()

        self.onCitySelection = selectedCityAirports
            .asEmpty()
        
        let coordinatesKeyedOnId = selectedCityAirports
            .map { [unowned self] in
                $0.map { (id: $0.id, coordinate: databaseInteractor.fetchAirportCoordinate(CLLocationCoordinate2D.self,
                                                                   by: $0.id)) }
            }
            .share()
        
        self.boundingBox = coordinatesKeyedOnId
            .map { $0.compactMap { $0.coordinate } }
            .map { coordinates in
                let minLatitude = coordinates.map { $0.latitude }.min()
                let maxLatitude = coordinates.map { $0.latitude }.max()
                let minLongitude = coordinates.map { $0.longitude }.min()
                let maxLongitude = coordinates.map { $0.longitude }.max()
                
                let maxYminX = Coordinate(lat: minLatitude, lon: maxLongitude)
                let minYmaxX = Coordinate(lat: maxLatitude, lon: minLongitude)
                
                return CoordinateBounds(maxYminX: maxYminX, minYmaxX: minYmaxX)
            }
            .compactMap { $0 }

        let airportsByCityPointAnnotations = coordinatesKeyedOnId
            .map { $0.compactMap { PointAnnotation(location: $0.coordinate,
                                                   airportId: $0.id.toString()) } }

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
        
        self.onAirportSelection = selectedAirport.asEmpty()
        
        self.dismissDetailView = searchingEnded.asObservable()
        
        self.airportCoordinate = selectedAirport
            .compactMap { Coordinate(lat: $0.latitudeDeg, lon: $0.longitudeDeg) }
        
        let airportAnnotation = airportCoordinate
            .filter { _ in !self.onCityPresentation } // TODO: TEMPORARY
            .compactMap { PointAnnotation(location: $0) }
            .map { [$0] }
        
        self.pointAnnotations = RxObservable.merge(
            airportsByCityPointAnnotations,
            airportAnnotation,
            searchingEnded.map { [] })
        
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
    
    func didSelectPointAnnotation(_ annotation: PointAnnotation) {
        selectedPointAnnotation.accept(annotation)
    }
    
    func didTapFiltersButton() {
        delegate?.openFilters()
    }
}
