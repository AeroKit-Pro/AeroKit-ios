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
    private let viewModel: AirportsViewModelType = AirportsViewModel()
    private let bannerViewController = BannerViewController()
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
        let constraint = spacerView.widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat.greatestFiniteMagnitude)
        constraint.isActive = true
        constraint.priority = .defaultLow

        let stackView = UIStackView(arrangedSubviews: [titleLabel, spacerView])
        stackView.axis = .horizontal

        navigationItem.titleView = stackView
    }

    private func bindViewModelInputs() {
//        airportsMainView.didBeginSearching
//            .subscribe(onNext: { self.viewModel.inputs.didBeginSearching() })
//            .disposed(by: disposeBag)
//
//        airportsMainView.didEndSearching
//            .subscribe(onNext: { self.viewModel.inputs.didEndSearching() })
//            .disposed(by: disposeBag)
//
//        airportsMainView.searchTextDidChange
//            .subscribe(onNext: { self.viewModel.inputs.searchInputDidChange(text: $0) })
//            .disposed(by: disposeBag)
//
//        airportsMainView.rxTable.itemSelected
//            .subscribe(onNext: { self.viewModel.inputs.didSelectItem(at: $0) })
//            .disposed(by: disposeBag)
    }

    private func bindViewModelOutputs() {
//        viewModel.outputs.onSearchStart
//            .subscribe(onNext: { self.airportsMainView.enterSearchingMode();
//                                 self.bannerViewController.collapse() })
//            .disposed(by: disposeBag)
//
//        viewModel.outputs.onSearchEnd
//            .subscribe(onNext: { self.airportsMainView.dismissSearchMode() })
//            .disposed(by: disposeBag)
//
//        viewModel.outputs.searchOutput
//            .bind(to: airportsMainView.rxTable.items(cellIdentifier: AirportCell.identifier,
//                                                     cellType: AirportCell.self)) { _, model, cell in
//                cell.viewModel = model
//            }
//            .disposed(by: disposeBag)
    }

}
