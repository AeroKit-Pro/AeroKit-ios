//
//  AirportFilterView.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 3.05.23.
//

import UIKit
import RxCocoa
import RxSwift
// TODO: this should probably be moved to a dedicated folder along with all the other protocols
protocol DatabaseRowRepresentable {
    var row: String { get }
}

protocol Indexable {
    var index: Int { get }
}

protocol AirportFilterViewType: UIView {
    var applyFiltersButtonTapped: ControlEvent<Void> { get }
    var filterInput: Observable<FilterInput> { get }
    func collectValues()
    func restoreState(with filterInput: FilterInput)
}

typealias FilterInput = (searchItem: AirportFilterItem,
                          runwayLength: String?,
                          runwaySurfaces: [RunwaySurface],
                          airportTypes: [AirportType],
                          lightAvailability: Bool)

final class AirportFilterView: UIView {
    let scrollView = UIScrollView()
    let stackView = UIStackView(axis: .vertical, spacing: 20)
    let airportFilterSearchItemsView = AirportFilterSearchItemsView<AirportFilterItem>()

    let airportsFilterRunwaysLengthView = AirportsFilterRunwaysLengthView()
    let airportsFilterRunwaysSurfacesSelectionView = AirportsFilterSelectionView<RunwaySurface>(title: "Runways surfaces")
    let airportsFilterAirportTypeSelectionView = AirportsFilterSelectionView<AirportType>(title: "Airports types")

    let airportsFilterRunwayLightView = AirportsFilterRunwayLightView()

    private let filterInputRelay = PublishRelay<FilterInput>()
    
    let applyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Apply changes", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
            
        button.backgroundColor = .flg_primary_dark
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectValues() {
        let input: FilterInput = (searchItem: airportFilterSearchItemsView.selectedItem,
                     runwayLength: airportsFilterRunwaysLengthView.enteredLength,
                     runwaySurfaces: airportsFilterRunwaysSurfacesSelectionView.selectedItems,
                     airportTypes: airportsFilterAirportTypeSelectionView.selectedItems,
                     lightAvailability: airportsFilterRunwayLightView.selectedState)
        filterInputRelay.accept(input)
    }

    private func setupLayout() {
        addSubviews(scrollView, applyButton)

        scrollView.addSubviews(stackView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
            make.width.equalToSuperview()
        }

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.width.equalToSuperview().inset(20)
        }

        applyButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        stackView.addArrangedSubview(airportFilterSearchItemsView)
        stackView.addArrangedSubview(airportsFilterRunwaysLengthView)
        stackView.addArrangedSubview(airportsFilterRunwaysSurfacesSelectionView)
        stackView.addArrangedSubview(airportsFilterAirportTypeSelectionView)
        stackView.addArrangedSubview(airportsFilterRunwayLightView)
    }

    private func setupUI() {
        backgroundColor = .white
    }
}

// MARK: - AirportFilterViewType
extension AirportFilterView: AirportFilterViewType {
    var applyFiltersButtonTapped: ControlEvent<Void> {
        applyButton.rx.tap
    }
    
    var filterInput: Observable<FilterInput> {
        filterInputRelay.asObservable()
    }
    
    func restoreState(with filterInput: FilterInput) {
        airportFilterSearchItemsView.selectedItem = filterInput.searchItem
        airportsFilterRunwaysLengthView.enteredLength = filterInput.runwayLength
        airportsFilterRunwaysSurfacesSelectionView.selectedItems = filterInput.runwaySurfaces
        airportsFilterAirportTypeSelectionView.selectedItems = filterInput.airportTypes
        airportsFilterRunwayLightView.selectedState = filterInput.lightAvailability
    }
}


