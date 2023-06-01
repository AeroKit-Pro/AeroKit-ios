//
//  ViewController.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 29.03.2023.
//

import UIKit
import RxSwift
import RxDataSources

final class AirportsViewController: UIViewController {
    
    private let airportsMainView: AirportsSceneViewType = AirportsMainView()
    private let viewModel: AirportsViewModelType
    private let bannerViewController = BannerViewController()
    private let dataSource = SearchTableViewDataSource()
    private let disposeBag = DisposeBag()
    
    init(viewModel: AirportsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    } 
    
    override func loadView() {
        view = airportsMainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModelInputs()
        bindViewModelOutputs()
        airportsMainView.rxTable.setDelegate(self).disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            addChild(bannerViewController)
            airportsMainView.addSubview(bannerViewController.view)
        }
    
    private func bindViewModelInputs() {
        airportsMainView.didBeginSearching
            .subscribe(onNext: viewModel.inputs.didBeginSearching)
            .disposed(by: disposeBag)
        
        airportsMainView.dismissSearchButton.tap
            .subscribe(onNext: viewModel.inputs.didEndSearching)
            .disposed(by: disposeBag)
        
        airportsMainView.rxTextFieldText
            .subscribe(onNext: viewModel.inputs.searchInputDidChange(text:))
            .disposed(by: disposeBag)
        
        airportsMainView.rxTable.itemSelected
            .subscribe(onNext: viewModel.inputs.didSelectItem(at:))
            .disposed(by: disposeBag)

        airportsMainView.didTapFilterButton
            .subscribe(onNext: viewModel.inputs.didTapFiltersButton)
            .disposed(by: disposeBag)    
    }
    
    private func bindViewModelOutputs() {
        viewModel.outputs.onSearchStart
            .subscribe(onNext: { self.airportsMainView.enterSearchingMode();
                                 self.bannerViewController.hide() })
            .disposed(by: disposeBag)
        
        viewModel.outputs.onSearchEnd
            .subscribe(onNext: airportsMainView.dismissSearchMode)
            .disposed(by: disposeBag)
        
        viewModel.outputs.searchFieldCanDismiss
            .subscribe(onNext: airportsMainView.searchFieldCanDismiss)
            .disposed(by: disposeBag)
        
        viewModel.outputs.dismissDetailView
            .subscribe(onNext: { self.bannerViewController.hide();
                                 self.airportsMainView.searchFieldCannotDismiss() })
            .disposed(by: disposeBag)
        
        viewModel.outputs.searchOutput
            .bind(to: airportsMainView.rxTable.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.outputs.pivotModel
            .subscribe(onNext: bannerViewController.refreshData(withPivotModel:))
            .disposed(by: disposeBag)
        
        viewModel.outputs.onItemSelection
            .subscribe(onNext: { self.airportsMainView.dismissSearchMode();
                                 self.bannerViewController.collapse() }) 
            .disposed(by: disposeBag)
        
        viewModel.outputs.airportCoordinate
            .subscribe(onNext: airportsMainView.ease(to:))
            .disposed(by: disposeBag)
        
        viewModel.outputs.airportAnnotation.asDriver(onErrorDriveWith: .empty())
            .drive(airportsMainView.bindablePointAnnotations)
            .disposed(by: disposeBag)
        
        viewModel.outputs.counterBadgeIsHidden.asDriver(onErrorDriveWith: .empty())
            .drive(airportsMainView.counterBadge.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.outputs.numberOfActiveFilters.asDriver(onErrorDriveWith: .empty())
            .drive(airportsMainView.counterBadge.text)
            .disposed(by: disposeBag)
    }
    
}
// traditional delegate methods are mainly used to manage table view appearance
extension AirportsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        // MARK: textLabel of UITableViewHeaderFooterView will be deprecated in next iOS versions
        headerView.textLabel?.textColor = .flg_primary_dark
        headerView.contentView.backgroundColor = .white
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
}
