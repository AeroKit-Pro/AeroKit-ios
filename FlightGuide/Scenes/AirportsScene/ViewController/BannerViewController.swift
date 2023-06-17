//
//  File.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 08.04.2023.
//

import UIKit
import RxSwift

final class BannerViewController: UIViewController {
    
    private let underlayView: BannerUnderlayView = .forAutoLayout()
    private let bannerView: AirportDetailView = .fromNib()
    private let viewModel: DetailViewModelType = DetailViewModel()
    private let disposeBag = DisposeBag()
    
    func refreshData(withPivotModel model: PivotModel) {
        viewModel.inputs.refresh(withPivotModel: model)
    }
    
    func expand() {
        UIView.animate(withDuration: 0.3) {
            self.underlayView.expand()
            self.view.superview?.layoutIfNeeded()
        }
    }
    
    func collapse() {
        UIView.animate(withDuration: 0) {
            self.underlayView.collapse()
            self.view.superview?.layoutIfNeeded()
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.underlayView.hide()
            self.view.superview?.layoutIfNeeded()
        }
    }
    
    override func loadView() {
        view = underlayView
        underlayView.addSubview(bannerView)
        bannerView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModelInputs()
        bindViewModelOutputs()
    }
    
    private func bindViewModelInputs() {
        bannerView.homeLinkGestureRecognizer.rx.event.asEmpty()
            .subscribe(onNext: viewModel.inputs.didTapOnHomeLinkLabel)
            .disposed(by: disposeBag)
        
        bannerView.wikipediaLinkGestureRecognizer.rx.event.asEmpty()
            .subscribe(onNext: viewModel.inputs.didTapOnWikipediaLinkLabel)
            .disposed(by: disposeBag)
        
        bannerView.isFavoriteButton.rx.isInSelectedState
            .subscribe(onNext: viewModel.inputs.didTapAddToFavoritesButton)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModelOutputs() {
        viewModel.outputs.name.asDriver(onErrorDriveWith: .empty())
            .drive(bannerView.name.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.identifier.asDriver(onErrorDriveWith: .empty())
            .drive(bannerView.identifier.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.type.asDriver(onErrorDriveWith: .empty())
            .drive(bannerView.type.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.elevation.asDriver(onErrorDriveWith: .empty())
            .drive(bannerView.elevation.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.municipality.asDriver(onErrorDriveWith: .empty())
            .drive(bannerView.municipality.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.frequency.asDriver(onErrorDriveWith: .empty())
            .drive(bannerView.frequency.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.wikipedia.asDriver(onErrorDriveWith: .empty())
            .drive(bannerView.wikipediaLink.rx.attributedText)
            .disposed(by: disposeBag)
        
        viewModel.outputs.homeLink.asDriver(onErrorDriveWith: .empty())
            .drive(bannerView.homeLink.rx.attributedText)
            .disposed(by: disposeBag)
        
        viewModel.outputs.phoneNumber.asDriver(onErrorDriveWith: .empty())
            .drive(bannerView.phoneNumber.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.runwayModels
            .bind(to: bannerView.runwaysTableView.rx.items(cellIdentifier: RunwayCell.identifier,
                                                           cellType: RunwayCell.self)) { _, model, cell in
                cell.viewModel = model
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.websiteURL
            .subscribe(onNext: { UIApplication.shared.open($0) })
            .disposed(by: disposeBag)
        
        viewModel.outputs.runwaysBlockHidden.asDriver(onErrorDriveWith: .empty())
            .drive(bannerView.runwaysBlock.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.outputs.invalidateWeatherTexts.asDriver(onErrorDriveWith: .empty())
            .drive(bannerView.metar.rx.text, bannerView.taf.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.metarShouldShowActivity.asDriver(onErrorDriveWith: .empty())
            .drive(bannerView.metarActivityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.outputs.tafShouldShowActivity.asDriver(onErrorDriveWith: .empty())
            .drive(bannerView.tafActivityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.outputs.metar.asDriver(onErrorDriveWith: .empty())
            .drive(bannerView.metar.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.taf.asDriver(onErrorDriveWith: .empty())
            .drive(bannerView.taf.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isFavorite.asDriver(onErrorDriveWith: .empty())
            .drive(bannerView.isFavoriteButton.rx.isInSelectedState)
            .disposed(by: disposeBag)
    }
    
}

