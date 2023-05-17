//
//  AirportsCoordinator.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 16.05.23.
//

import UIKit

final class AirportsCoordinator: BaseCoordinator {

    //MARK: - Lifecycle
    override func start() {
        openAirports()
    }

    func openAirports() {
        let scene = AirportAssembly(sceneOutput: self).makeScene()
        startingViewController = scene
        router.setRootModule(scene, hideBar: true)
    }
}

// MARK: - ChannelListSceneDelegate
extension AirportsCoordinator: AirportsSceneDelegate {
    func openFilters() {
        router.push(AirportFilterViewController(), animated: true)
    }
}
