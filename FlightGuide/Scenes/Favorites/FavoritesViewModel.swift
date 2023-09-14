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
    var promptViewIsHidden: Observable<Bool>! { get }
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
    var promptViewIsHidden: Observable<Bool>!
    
    private let onViewWillAppear = PublishRelay<Empty>()
    private let selectedItem = PublishRelay<IndexPath>()
    @UserDataStorage(key: UserDefaultsKey.savedIdObjectWithDate)
    private var savedFavorites: [IdObjectWithDate]?
    
    var inputs: FavoritesViewModelInputs { self }
    var outputs: FavoritesViewModelOutputs { self }
    
    init(delegate: FavoritesSceneDelegate?, notificationsCenter: NotificationCenterModuleInterface) {
        self.notificationCenter = notificationsCenter
        
        let models = onViewWillAppear
            .map { [unowned self] in
                savedFavorites?
                    .sorted { $0.date > $1.date }
                    .compactMap { databaseInteractor.fetchAirport(by: $0.id)?.first }
            }
            .skipNil()
        
        self.promptViewIsHidden = models
            .map { $0.notEmpty }
                
        self.favoriteAirportsModels = models
            .map { $0.map { AirportPreview(id: $0.id, name: $0.name, type: $0.type, municipality: $0.municipality, surfaces: $0.surfaces) } }
            .map { $0.map { AirportCellViewModel(with: $0, isFavorite: true) } }
        
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
