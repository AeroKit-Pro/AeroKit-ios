//
//  FavoritesView.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 25.05.2023.
//

import UIKit
import RxSwift

protocol FavoritesViewType: UIView {
    var rxTableView: Reactive<UITableView> { get }
}

final class FavoritesView: UIView {
    
    private let tableView = UITableView()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(21)
        }
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: String(describing: AirportCell.self), bundle: nil),
                                   forCellReuseIdentifier: AirportCell.identifier)
        tableView.dataSource = nil
    }
    
}

extension FavoritesView: FavoritesViewType {
    var rxTableView: RxSwift.Reactive<UITableView> {
        tableView.rx
    }
}
