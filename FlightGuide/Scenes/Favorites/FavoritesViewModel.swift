//
//  FavoritesViewModel.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 25.05.2023.
//

import RxSwift
import RxRelay

protocol FavoritesSceneDelegate {
 //   func openFavorite()
}

protocol FavoritesViewModelInputs {
    func viewDidLoad()
}

protocol FavoritesViewModelOutputs {
    typealias Empty = ()
    typealias AirportCellViewModels = [AirportCellViewModel]

    var favoriteAirportsModels: Observable<AirportCellViewModels>! { get }
}

protocol FavoritesViewModelType {
    var inputs: FavoritesViewModelInputs { get }
    var outputs: FavoritesViewModelOutputs { get }
}

final class FavoritesViewModel: FavoritesViewModelType, FavoritesViewModelOutputs {
    
    private let databaseInteractor = DatabaseInteractor()

    var favoriteAirportsModels: Observable<AirportCellViewModels>!
    
    private let viewLoaded = PublishRelay<Empty>()

    var inputs: FavoritesViewModelInputs { self }
    var outputs: FavoritesViewModelOutputs { self }

    init(delegate: FavoritesSceneDelegate?) {
        let models = viewLoaded
            .compactMap { [unowned self] in databaseInteractor.fetchFavorites() }
        
        self.favoriteAirportsModels = models
            .map { $0.map { AirportCellViewModel(with: $0) } }
    }
    
}
    
// MARK: - AirportsViewModelInputs
extension FavoritesViewModel: FavoritesViewModelInputs {
    func viewDidLoad() {
        viewLoaded.accept(Empty())
    }
}
