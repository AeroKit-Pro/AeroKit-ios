//
//  ViewController.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 29.03.2023.
//

import UIKit
import RxSwift

final class AirportsViewController: UIViewController {
    
    private let airportsMainView: AirportsSceneViewType = AirportsMainView()
    private let viewModel: AirportsViewModelType = AirportsViewModel()
    private let bannerViewController = BannerViewController()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = airportsMainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModelInputs()
        bindViewModelOutputs()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addChild(bannerViewController)
        airportsMainView.addSubview(bannerViewController.view)
    }
    
    private func bindViewModelInputs() {
        airportsMainView.didBeginSearching
            .subscribe(onNext: { self.viewModel.inputs.didBeginSearching() })
            .disposed(by: disposeBag)
        
        airportsMainView.didEndSearching
            .subscribe(onNext: { self.viewModel.inputs.didEndSearching() })
            .disposed(by: disposeBag)
        
        airportsMainView.searchTextDidChange
            .subscribe(onNext: { self.viewModel.inputs.searchInputDidChange(text: $0) })
            .disposed(by: disposeBag)
        
        airportsMainView.rxTable.itemSelected
            .subscribe(onNext: { self.viewModel.inputs.didSelectItem(at: $0) })
            .disposed(by: disposeBag)

        airportsMainView.didTapFilterButton
            .subscribe(onNext: { [weak self] in
                // TODO: remove
                self?.navigationController?.pushViewController(AirportFilterViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModelOutputs() {
        viewModel.outputs.onSearchStart
            .subscribe(onNext: { self.airportsMainView.enterSearchingMode();
                                 self.bannerViewController.collapse() })
            .disposed(by: disposeBag)
        
        viewModel.outputs.onSearchEnd
            .subscribe(onNext: { self.airportsMainView.dismissSearchMode() })
            .disposed(by: disposeBag)
        
        viewModel.outputs.searchOutput
            .bind(to: airportsMainView.rxTable.items(cellIdentifier: AirportCell.identifier,
                                                     cellType: AirportCell.self)) { _, model, cell in
                cell.viewModel = model
            }
            .disposed(by: disposeBag)
        /*
        viewModel.outputs.onItemSelection
            .subscribe(onNext: { self.airportsMainView.dismissSearchMode();
                self.bannerViewController.expand() })
            .disposed(by: disposeBag)
        
        viewModel.outputs.airportCoordinate
            .subscribe(onNext: { self.airportsMainView.ease(to: $0) })
            .disposed(by: disposeBag)
        
        viewModel.outputs.airportAnnotation
            .asDriver(onErrorDriveWith: .empty())
            .drive(airportsMainView.bindablePointAnnotations)
            .disposed(by: disposeBag)
         
        viewModel.outputs.selectedAirport
            .subscribe(onNext: { self.bannerViewController.refreshData(with: $0) })
            .disposed(by: disposeBag)
          */
    }
    
}
