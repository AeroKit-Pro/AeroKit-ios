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
import CoreLocation
//TODO: Enum with states
protocol AirportsSceneViewType: UIView {
    typealias PointAnnotations = [PointAnnotation]
    
    var bindablePointAnnotations: Binder<PointAnnotations> { get }
    var tappedAnnotation: ControlEvent<PointAnnotation> { get }
    var didBeginSearching: ControlEvent<()> { get }
    var didEndSearching: ControlEvent<()> { get }
    var didTapFilterButton: ControlEvent<()> { get }
    var didTapShowLocationButton: ControlEvent<()> { get }
    var counterBadge: Reactive<CounterBadge> { get }
    var dismissSearchButton: Reactive<UIButton> { get }
    var rxTextFieldText: ControlProperty<String?> { get }
    var rxTable: Reactive<UITableView> { get }
    var rxPromptView: Reactive<PromptView> { get }
    var tappedOnRequestMail: RxSwift.Observable<()> { get }
    var locationAuthorizationStatus: CLAuthorizationStatus { get }
    func enterSearchingMode()
    func dismissSearchMode()
    func searchFieldCannotDismiss()
    func searchFieldCanDismiss() 
    func ease(to coordinate: CLLocationCoordinate2D)
    func easeToLatestLocation()
    func fitCameraInto(_ bounds: CoordinateBounds)
}

final class AirportsMainView: UIView {
    
    private let mapView: MapView
    private let showLocationButton = ShowLocationButton()
    private let searchField = SearchFieldView(placeholder: "Search for airport or city")
    private let blankView = BlankView()
    private let airportsTableView = UITableView()
    private let promptView = PromptView(image: .airports_not_found,
                                        message: "Unfortunately, we were unable to find relevant airports",
                                        style: .small)
    private let hyperLink = HyperLinkText(text: "If you know such airport, please \n leave a request",
                                          tapPart: "leave a request",
                                          link: "",
                                          font: .systemFont(ofSize: 13),
                                          textColor: .flg_secondary_gray)
    
    private lazy var annotationsManager: PointAnnotationManager = {
        mapView.annotations.makePointAnnotationManager()
    }()
    
    override init(frame: CGRect = .zero) {
        // US center
        let camOptions = CameraOptions(center: CLLocationCoordinate2D(latitude: 39.8097343, longitude: -98.5556199), zoom: 2.2)
        let initOptions = MapInitOptions(cameraOptions: camOptions, styleURI: StyleURI(url: BundleURLs.mapStyle))
        mapView = MapView(frame: .zero, mapInitOptions: initOptions)
        super.init(frame: frame)
        setupMapView()
        setupSearchField()
        setupBlankView()
        setupTableView()
        setupPromptView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMapView() {
        addSubview(mapView)
        mapView.addSubview(showLocationButton)
        mapView.snp.makeConstraints { $0.edges.equalToSuperview() }
        showLocationButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(100)
        }
        let puckConfiguration = Puck2DConfiguration.makeDefault()
        mapView.location.options.puckType = .puck2D(puckConfiguration)
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
    
    private func setupPromptView() {
        hyperLink.textAlignment = .center
        hyperLink.layer.masksToBounds = false
        promptView.addElement(hyperLink)
        airportsTableView.addSubview(promptView)
        promptView.snp.makeConstraints {
            $0.top.equalTo(searchField.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview().inset(70)
        }
    }
    
}

extension AirportsMainView: AirportsSceneViewType {
    var bindablePointAnnotations: Binder<PointAnnotations> { // ??? элиас ???
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
    
    var rxPromptView: Reactive<PromptView> {
        promptView.rx
    }

    var didTapFilterButton: ControlEvent<()> {
        searchField.didTapFilterButton
    }
    
    var didTapShowLocationButton: ControlEvent<()> {
        showLocationButton.rx.tap
    }
    
    var counterBadge: Reactive<CounterBadge> {
        searchField.rxCounterBadge
    }
    
    var dismissSearchButton: Reactive<UIButton> {
        searchField.rxDismissSearchButton
    }
    
    var locationAuthorizationStatus: CLAuthorizationStatus {
        mapView.location.locationProvider.authorizationStatus
    }
    
    var locationAuthorizationDelegate: LocationPermissionsDelegate? {
        mapView.location.delegate
    }
    
    var tappedOnRequestMail: RxSwift.Observable<()> {
        hyperLink.tappedOnLinkPart.asObservable()
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
        let options = CameraOptions(center: coordinate, zoom: 12)
        mapView.camera.fly(to: options, duration: 0.4)
    }
    
    func easeToLatestLocation() {
        guard let location = mapView.location.latestLocation else { return }
        ease(to: location.coordinate)
    }
    
    func fitCameraInto(_ bounds: CoordinateBounds) {
        var insets = UIEdgeInsets.allSides(100)
        insets.top = 200
        let camera = mapView.mapboxMap.camera(for: bounds,
                                              padding: insets,
                                              bearing: 0,
                                              pitch: 0)
        mapView.mapboxMap.setCamera(to: camera)
    }
}
