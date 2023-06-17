//
//  FavoritesViewModel.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 25.05.2023.
//

import RxSwift
import RxRelay
import Foundation

protocol FavoritesSceneDelegate {
 //   func openFavorite()
}

protocol FavoritesViewModelInputs {
    func viewWillAppear()
    func didSelectItem(at indexPath: IndexPath)
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
    // TODO: DI
    private let notificationCenter: NotificationCenterModuleInterface
    private let disposeBag = DisposeBag()

    var favoriteAirportsModels: Observable<AirportCellViewModels>!
    
    private let onViewWillAppear = PublishRelay<Empty>()
    private let selectedItem = PublishRelay<IndexPath>()
    
    var inputs: FavoritesViewModelInputs { self }
    var outputs: FavoritesViewModelOutputs { self }
    
    init(delegate: FavoritesSceneDelegate?, notificationsCenter: NotificationCenterModuleInterface) {
        self.notificationCenter = notificationsCenter
        
        let models = onViewWillAppear
            .compactMap { [unowned self] in databaseInteractor.fetchFavorites() }
        
        self.favoriteAirportsModels = models
            .map { $0.map { AirportCellViewModel(with: $0) } }
        // the consumer in that case is not the view controller
        selectedItem.withLatestFrom(models) { ($0, $1) }
            .map { indexPath, models in
                models[indexPath.row].id
            }
            .subscribe(onNext: { [unowned self] id in
                notificationCenter.post(name: .didSelectFavouriteAirport, object: id)
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - AirportsViewModelInputs
extension FavoritesViewModel: FavoritesViewModelInputs {
    func viewWillAppear() {
        onViewWillAppear.accept(Empty())
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        selectedItem.accept(indexPath)
    }
}
