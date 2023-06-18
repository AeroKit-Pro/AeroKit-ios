//
//  GetStartedViewController.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 18.06.23.
//

import UIKit

protocol GetStartedSceneOutput: AnyObject {
    func showLoginScene()
    func showSignUpScene()
}

final class GetStartedViewController: UIViewController {
    let getStartedView = GetStartedView()
    
    var onTapLogin: (() -> Void)?
    var onTapSignUp: (() -> Void)?

    weak var delegate: GetStartedSceneOutput?

    override func loadView() {
        view = getStartedView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)

        getStartedView.onTapLogin = { [weak self] in
            self?.delegate?.showLoginScene()
        }
        getStartedView.onTapSignUp = { [weak self] in
            self?.delegate?.showSignUpScene()
        }
    }
}

