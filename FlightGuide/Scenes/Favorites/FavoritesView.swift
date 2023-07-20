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
    var rxPromptView: Reactive<PromptView> { get }
}

final class FavoritesView: UIView {
    
    private let tableView = UITableView()
    private let promptView = PromptView(image: .bookmark,
                                        message: "Here will be your \n favorite airports",
                                        style: .medium)
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupTableView()
        setupPromptView()
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
    
    private func setupPromptView() {
        addSubviews(promptView)
        promptView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(150)
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview().inset(70)
        }
    }
    
}

extension FavoritesView: FavoritesViewType {
    var rxTableView: Reactive<UITableView> {
        tableView.rx
    }
    
    var rxPromptView: Reactive<PromptView> {
        promptView.rx
    }
}
