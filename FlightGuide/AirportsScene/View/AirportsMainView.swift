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

protocol AirportsSceneViewType: UIView {
    typealias PointAnnotations = [PointAnnotation]
    
    var bindablePointAnnotations: RxSwift.Binder<PointAnnotations> { get }
    var tappedAnnotation: ControlEvent<PointAnnotation> { get }
    var didBeginSearching: ControlEvent<()> { get }
    var didEndSearching: ControlEvent<()> { get }
    var searchTextDidChange: ControlProperty<String?> { get }
    var rxTable: Reactive<UITableView> { get }
    func enterSearchingMode()
    func dismissSearchMode()
    func ease(to coordinate: CLLocationCoordinate2D)
}

final class AirportsMainView: UIView {
    
    private let mapView: MapView
    private let searchField = SearchFieldView(placeholder: "Search places")
    private let blankView = BlankView()
    private let airportsTableView = UITableView()
    
    private lazy var annotationsManager: PointAnnotationManager = {
        mapView.annotations.makePointAnnotationManager()
    }()
    
    override init(frame: CGRect = .zero) {
        // поправить эту хуйню - убрать форс, УРЛ в константы // WARN
        let options = MapInitOptions(styleURI: StyleURI(url: try! "http://45.12.19.184/map_style".asURL()))
        mapView = MapView(frame: .zero, mapInitOptions: options)
        super.init(frame: frame)
        setupMapView()
        setupSearchField()
        setupBlankView()
        setupTableView()
    }
    
    private func setupMapView() {
        addSubview(mapView)
        mapView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func setupSearchField() {
        addSubview(searchField)
        searchField.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(10)
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(40)
        }
        searchField.layer.cornerRadius = 20
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
        airportsTableView.dataSource = nil
        airportsTableView.separatorStyle = .none
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    var searchTextDidChange: ControlProperty<String?> {
        searchField.textDidChange
    }
    
    var rxTable: Reactive<UITableView> {
        airportsTableView.rx
    }
    
    func enterSearchingMode() {
        blankView.show(withDuration: 0.2)
        airportsTableView.isHidden = false
        searchField.addBorder(withDuration: 0.2)
        searchField.removeShadow(withDuration: 0.2)
    }
    
    func dismissSearchMode() {
        blankView.hide(withDuration: 0.2)
        airportsTableView.isHidden = true
        searchField.resignFocus()
        searchField.removeBorder(withDuration: 0.2)
        searchField.addShadow(withDuration: 0.2)
    }
    
    func ease(to coordinate: CLLocationCoordinate2D) {
        let options = CameraOptions(center: coordinate, zoom: 8)
        mapView.camera.ease(to: options, duration: 0.4)
    }
}
