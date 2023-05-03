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
    private let contentView: AirportDetailView = .fromNib()
    private let viewModel: DetailViewModelType = DetailViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = underlayView
        underlayView.addSubview(contentView)
        contentView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModelOutputs()
    }
    
    private func bindViewModelOutputs() {
        viewModel.outputs.name
            .asDriver(onErrorDriveWith: .empty())
            .drive(contentView.name.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.identifier
            .asDriver(onErrorDriveWith: .empty())
            .drive(contentView.identifier.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.type
            .asDriver(onErrorDriveWith: .empty())
            .drive(contentView.type.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.elevation
            .asDriver(onErrorDriveWith: .empty())
            .drive(contentView.elevation.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.municipality
            .asDriver(onErrorDriveWith: .empty())
            .drive(contentView.municipality.rx.text)
            .disposed(by: disposeBag)
    }
    
    func refreshData(with airport: Airport) {
        viewModel.inputs.refresh(with: airport)
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
    
}

