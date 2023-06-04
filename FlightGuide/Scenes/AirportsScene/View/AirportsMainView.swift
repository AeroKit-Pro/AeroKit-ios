//
//  AirportsMainView.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 29.03.2023.
//

import UIKit
import SnapKit
import MapboxMaps
import RxCocoa
import RxSwift
//TODO: Enum with states
protocol AirportsSceneViewType: UIView {
    typealias PointAnnotations = [PointAnnotation]
    
    var bindablePointAnnotations: Binder<PointAnnotations> { get }
    var tappedAnnotation: ControlEvent<PointAnnotation> { get }
    var didBeginSearching: ControlEvent<()> { get }
    var didEndSearching: ControlEvent<()> { get }
    var didTapFilterButton: ControlEvent<()> { get }
    var counterBadge: Reactive<CounterBadge> { get }
    var dismissSearchButton: Reactive<UIButton> { get }
    var rxTextFieldText: ControlProperty<String?> { get }
    var rxTable: Reactive<UITableView> { get }
    func enterSearchingMode()
    func dismissSearchMode()
    func searchFieldCannotDismiss()
    func searchFieldCanDismiss() 
    func ease(to coordinate: CLLocationCoordinate2D)
}

final class AirportsMainView: UIView {
    
    private let mapView: MapView
    private let searchField = SearchFieldView(placeholder: "Search for airport or city")
    private let blankView = BlankView()
    private let airportsTableView = UITableView()
    
    private lazy var annotationsManager: PointAnnotationManager = {
        mapView.annotations.makePointAnnotationManager()
    }()
    
    override init(frame: CGRect = .zero) {
       // let options = MapInitOptions(styleURI: StyleURI(url: try! "http://45.12.19.184/map_style".asURL()))
        mapView = MapView(frame: .zero)
        super.init(frame: frame)
        setupMapView()
        setupSearchField()
        setupBlankView()
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMapView() {
        addSubview(mapView)
        mapView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func setupSearchField() {
        addSubview(searchField)
        searchField.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(10)
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(45)
            $0.height.equalTo(50)
        }
        searchField.layer.cornerRadius = 15
    }
    
    private func setupBlankView() {
        mapView.addSubview(blankView)
        blankView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        blankView.alpha = 0
        blankView.isHidden = true
    }
    
    private func setupTableView() {
        addSubview(airportsTableView)
        airportsTableView.snp.makeConstraints {
            $0.top.equalTo(searchField.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(10)
        }
        airportsTableView.backgroundColor = .clear
        airportsTableView.isHidden = true
        airportsTableView.register(UINib(nibName: String(describing: AirportCell.self), bundle: nil),
                                   forCellReuseIdentifier: AirportCell.identifier)
        airportsTableView.register(UINib(nibName: String(describing: CityCell.self), bundle: nil),
                                   forCellReuseIdentifier: CityCell.identifier)
        airportsTableView.dataSource = nil
        airportsTableView.separatorStyle = .none
    }
    
}

extension AirportsMainView: AirportsSceneViewType {
    var bindablePointAnnotations: RxSwift.Binder<PointAnnotations> { // ??? элиас ???
        annotationsManager.rx.annotations
    }
    
    var tappedAnnotation: ControlEvent<PointAnnotation> {
        annotationsManager.rx.didDetectTappedAnnotation
    }
    
    var didBeginSearching: ControlEvent<()> {
        searchField.textFieldDidBeginEditing
    }
    
    var didEndSearching: ControlEvent<()> {
        searchField.textFieldDidEndEditing
    }
    
    var rxTextFieldText: ControlProperty<String?> {
        searchField.rxTextFieldText
    }
    
    var rxTable: Reactive<UITableView> {
        airportsTableView.rx
    }

    var didTapFilterButton: ControlEvent<()> {
        searchField.didTapFilterButton
    }
    
    var counterBadge: Reactive<CounterBadge> {
        searchField.rxCounterBadge
    }
    
    var dismissSearchButton: Reactive<UIButton> {
        searchField.rxDismissSearchButton
    }
    
    func enterSearchingMode() {
        blankView.show(withDuration: 0.2)
        airportsTableView.isHidden = false
        searchField.addBorder(withDuration: 0.2)
        searchField.removeShadow(withDuration: 0.2)
        searchField.showDismissButton()
    }
    
    func searchFieldCanDismiss() {
        searchField.showDismissButton()
    }
    
    func dismissSearchMode() {
        blankView.hide(withDuration: 0.2)
        airportsTableView.isHidden = true
        searchField.resignFocus()
        searchField.removeBorder(withDuration: 0.2)
        searchField.addShadow(withDuration: 0.2)
    }
    
    func searchFieldCannotDismiss() {
        searchField.showMagnifierImage()
    }
    
    func ease(to coordinate: CLLocationCoordinate2D) {
        let options = CameraOptions(center: coordinate, zoom: 8)
        mapView.camera.ease(to: options, duration: 0.4)
    }
}
