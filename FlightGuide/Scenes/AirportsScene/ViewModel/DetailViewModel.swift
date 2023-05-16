//
//  DetailViewModel.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 09.04.2023.
//

import RxSwift
import RxCocoa
import UIKit

protocol DetailViewModelInputs {
    func refresh(withPivotModel model: PivotModel)
}

protocol DetailViewModelOutputs {
    var image: Observable<UIImage>! { get }
    var name: Observable<String>! { get }
    var identifier: Observable<String>! { get }
    var type: Observable<String>! { get }
    var elevation: Observable<String>! { get }
    var municipality: Observable<String>! { get }
    var frequency: Observable<String>! { get }
    var wikipedia: Observable<String>! { get }
    var homeLink: Observable<String>! { get }
}

protocol DetailViewModelType {
    var inputs: DetailViewModelInputs { get }
    var outputs: DetailViewModelOutputs { get }
}

final class DetailViewModel: DetailViewModelInputs, DetailViewModelOutputs, DetailViewModelType {
    
    init() {
        
        
        
    }
    
    var image: Observable<UIImage>!
    var name: Observable<String>!
    var identifier: Observable<String>!
    var type: Observable<String>!
    var elevation: Observable<String>!
    var municipality: Observable<String>!
    var frequency: Observable<String>!
    var wikipedia: Observable<String>!
    var homeLink: Observable<String>!
    
    func refresh(withPivotModel model: PivotModel) {
        airportInfo.accept(model)
    }
    private let airportInfo = PublishRelay<PivotModel>()
    
    var inputs: DetailViewModelInputs { self }
    var outputs: DetailViewModelOutputs { self }
    
}
