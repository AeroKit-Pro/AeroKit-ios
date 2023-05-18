//
//  AirportsCoordinator.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 16.05.23.
//

import UIKit
import RxSwift
import RxCocoa

protocol FilterInputPassing {
    var filterInput: Observable<FilterInput> { get }
    func updateFilterInput(_ input: FilterInput)
}

final class AirportsCoordinator: BaseCoordinator {
    
    private let filterInputRelay = PublishRelay<FilterInput>()

    //MARK: - Lifecycle
    override func start() {
        openAirports()
    }

    func openAirports() {
        let scene = AirportAssembly(sceneOutput: self, filterInputPassing: self).makeScene()
        startingViewController = scene
        router.setRootModule(scene, hideBar: true)
    }
}

// MARK: - ChannelListSceneDelegate
extension AirportsCoordinator: AirportsSceneDelegate {
    func openFilters() {
        let scene = FilterAssembly(sceneOutput: self, filterInputPassing: self).makeScene()
        router.push(scene, animated: true)
    }
}

extension AirportsCoordinator: FilterSceneDelegate {
    func closeFilters() {
        router.popModule(animated: true)
    }
}

extension AirportsCoordinator: FilterInputPassing {
    var filterInput: Observable<FilterInput> {
        filterInputRelay.asObservable()
    }
    
    func updateFilterInput(_ input: FilterInput) {
        filterInputRelay.accept(input)
    }
}
