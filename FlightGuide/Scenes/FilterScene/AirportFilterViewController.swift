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
    private let viewModel: AirportsViewModelType
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
    
    init(viewModel: AirportsViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }   
    
    override func loadView() {
        view = airportFilterView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()

        bindViewModelInputs()
        bindViewModelOutputs()
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
        airportFilterView.applyFiltersButtonTapped.subscribe(onNext: { [unowned self] in
            viewModel.inputs.didTapApplyFiltersButton()
        })
        .disposed(by: disposeBag)
        
        airportFilterView.filterInput.subscribe(onNext: { [unowned self] in
            viewModel.inputs.didCollectFilterInput(filterInput: $0)
        })
        .disposed(by: disposeBag)
    }

    private func bindViewModelOutputs() {
        viewModel.outputs.collectFilters
            .subscribe(onNext: { [unowned self] in
                airportFilterView.collectValues()
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.dismissFilterScene
            .subscribe(onNext: { [unowned self] in
                navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
}
