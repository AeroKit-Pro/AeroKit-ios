//
//  SplashViewController.swift
//  HeyDay
//
//  Created by Eugene Kleban on 27.05.22.
//  
//

import UIKit

final class SplashViewController: UIViewController {

    // MARK: Properties
    var presenter: SplashViewModelInterface?

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        presenter?.viewDidLoad()
    }
}

// MARK: SplashView Protocol
extension SplashViewController: SplashViewInterface {
}
