//
//  FavoritesCoordinator.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 25.05.2023.
//

import Foundation

final class FavoritesCoordinator: BaseCoordinator {
    
    override func start() {
        openFavorites()
        addNavigationBarPermanentShadow()
    }

    func openFavorites() {
        let scene = FavoritesAssembly(sceneOutput: self).makeScene()
        startingViewController = scene
        router.setRootModule(scene, hideBar: false)
    }
    
    private func addNavigationBarPermanentShadow() {
        router.root?.addNavigationBarPermanentShadow()
    }

}

extension FavoritesCoordinator: FavoritesSceneDelegate {}
