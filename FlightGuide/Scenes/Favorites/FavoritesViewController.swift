//
//  FavoritesViewController.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 25.05.2023.
//

import UIKit
import RxSwift

final class FavoritesViewController: UIViewController {
    
    private let favoritesView: FavoritesViewType = FavoritesView()
    private let viewModel: FavoritesViewModelType
    private let disposeBag = DisposeBag()
    
    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupNavigationTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = favoritesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModelInputs()
        bindViewModelOutputs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.inputs.viewWillAppear()
    }
    
    private func bindViewModelInputs() {
        favoritesView.rxTableView.itemSelected
            .subscribe(onNext: viewModel.inputs.didSelectItem(at:))
            .disposed(by: disposeBag)
    }
    
    private func bindViewModelOutputs() {
        viewModel.outputs.favoriteAirportsModels
            .bind(to: favoritesView.rxTableView.items(cellIdentifier: AirportCell.identifier,
                                                      cellType: AirportCell.self)) { _, model, cell in
                cell.viewModel = model
            }
            .disposed(by: disposeBag)
    }
    
    private func setupNavigationTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "Favourites"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left

        let spacerView = UIView()
        let constraint = spacerView.widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat.greatestFiniteMagnitude) // prints a warning: "This NSLayoutConstraint is being configured with a constant that exceeds internal limits..."
        constraint.isActive = true
        constraint.priority = .defaultLow

        let stackView = UIStackView(arrangedSubviews: [titleLabel, spacerView])
        stackView.axis = .horizontal

        navigationItem.titleView = stackView
    }
    
    
}


