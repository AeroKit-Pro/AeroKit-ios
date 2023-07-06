//
//  AboutViewController.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 6.07.23.
//

import UIKit

final class AboutViewController: UIViewController {
    let aboutView = AboutView()

    override func loadView() {
        view = aboutView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "About us"
    }
}
