//
//  AirportFilterViewController.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 3.05.23.
//

import UIKit
import RxSwift

final class AirportFilterViewController: UIViewController {

    private let airportFilterView: AirportFilterViewType = AirportFilterView()
    var viewModel: AirportsViewModelType!
    private let disposeBag = DisposeBag()

    let rightBarButton: UIButton = {
        let button = UIButton()

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributedString = NSAttributedString(string: "Reset", attributes: attributes)

        button.setAttributedTitle(attributedString, for: .normal)
        return button
    }()

    override func loadView() {
        view = airportFilterView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()

        bindViewModelInputs()
        bindViewModelOutputs()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    private func configureNavigationBar() {
        setupNavigationTitle()

        let backImage = UIImage(named: "navigationBar_backArrow")
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        setIsEnabledResetButton(false)
    }

    func setIsEnabledResetButton(_ isEnabled: Bool) {
        rightBarButton.isEnabled = isEnabled
        rightBarButton.alpha = isEnabled ? 1 : 0.5
    }

    private func setupNavigationTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "Filters"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .left

        let spacerView = UIView()
        let constraint = spacerView.widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat.greatestFiniteMagnitude) // prints a warning: "This NSLayoutConstraint is being configured with a constant that exceeds internal limits..." 
        constraint.isActive = true
        constraint.priority = .defaultLow

        let stackView = UIStackView(arrangedSubviews: [titleLabel, spacerView])
        stackView.axis = .horizontal

        navigationItem.titleView = stackView
    }

    private func bindViewModelInputs() {

    }

    private func bindViewModelOutputs() {

    }

}
