//
//  FilterViewModel.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 18.05.2023.
//

import RxSwift
import RxRelay

protocol FilterSceneDelegate: Coordinatable {
    func closeFilters()
}

protocol FilterViewModelInputs {
    func viewDidLoad()
    func didTapApplyFiltersButton()
    func didCollectValues(filterInput: FilterInput)
}

protocol FilterViewModelOutputs {
    typealias Empty = ()

    var filterState: Observable<FilterInput>! { get }
    var collectFilters: Observable<Empty>! { get }
}

protocol FilterViewModelType {
    var inputs: FilterViewModelInputs { get }
    var outputs: FilterViewModelOutputs { get }
}

final class FilterViewModel: FilterViewModelType, FilterViewModelOutputs {
    
    private let delegate: FilterSceneDelegate?
    private let filterInputPassing: FilterInputPassing
    
    var filterState: Observable<FilterInput>!
    var collectFilters: Observable<Empty>!
    
    private let viewLoaded = PublishRelay<Empty>()
    private let applyFiltersButtonTapped = PublishRelay<Empty>()

    var inputs: FilterViewModelInputs { self }
    var outputs: FilterViewModelOutputs { self }

    init(delegate: FilterSceneDelegate?, filterInputPassing: FilterInputPassing) {
        self.delegate = delegate
        self.filterInputPassing = filterInputPassing
        
        self.filterState = viewLoaded.withLatestFrom(filterInputPassing.filterInput)
            .skipNil()
        
        self.collectFilters = applyFiltersButtonTapped.asObservable()
    }
    
}
    
// MARK: - AirportsViewModelInputs
extension FilterViewModel: FilterViewModelInputs {
    func viewDidLoad() {
        viewLoaded.accept(Empty())
    }
    
    func didTapApplyFiltersButton() {
        applyFiltersButtonTapped.accept(Empty())
    }
    
    func didCollectValues(filterInput: FilterInput) {
        filterInputPassing.updateFilterInput(filterInput)
        delegate?.closeFilters()
    }
}
