//
//  AirportFilterView.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 3.05.23.
//

import UIKit

protocol AirportFilterViewType: UIView {

}

final class AirportFilterView: UIView {
    let scrollView = UIScrollView()
    let stackView = UIStackView(axis: .vertical, spacing: 20)
    let airportFilterSearchItemsView = AirportFilterSearchItemsView()

    let airportsFilterRunwaysLengthView = AirportsFilterRunwaysLengthView()
    let airportsFilterRunwaysSurfacesSelectionView = AirportsFilterSelectionView<RunwaySurface>(title: "Runways surfaces")
    let airportsFilterAirportTypeSelectionView = AirportsFilterSelectionView<AirportType>(title: "Airports types")

    let airportsFilterRunwayLightView = AirportsFilterRunwayLightView()

    let applyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Apply changes", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
            
        button.backgroundColor = UIColor.hex(0x333333)
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

    private func setupLayout() {
        addSubviewsWithoutAutoresizingMask(scrollView, applyButton)

        scrollView.addSubviewsWithoutAutoresizingMask(stackView)
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

}


