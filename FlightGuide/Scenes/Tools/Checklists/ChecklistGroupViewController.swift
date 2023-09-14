//
//  ChecklistGroupViewController.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 5.06.23.
//

import UIKit

protocol ChecklistGroupSceneDelegate: AnyObject {
    func showChecklistsInspection(items:  [ChecklistWithItemsModel])
}

final class ChecklistGroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        let tableHeaderView = ChecklistsTableHeaderView()
        tableHeaderView.configure(title: "Select your checklists:", underlinedText: nil)
        tableView.register(ChecklistsTableCell.self, forCellReuseIdentifier: String(describing: ChecklistsTableCell.self))

        tableView.setSystemLayoutSizeFittingHeaderView(tableHeaderView)

        return tableView
    }()

    private let buttonContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let startChecklistsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start all checklists", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    var items = [ChecklistWithItemsModel]()
    weak var delegate: ChecklistGroupSceneDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Find checklists"
        setupLayout()
        startChecklistsButton.addAction(UIAction { [weak self] _ in self?.didTapStartChecklistsButton() }, for: .touchUpInside)
    }

    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }

        view.addSubview(buttonContainerView)
        buttonContainerView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(96)
        }
        buttonContainerView.addSubviews(startChecklistsButton)
        startChecklistsButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.leading.trailing.equalToSuperview().inset(20)
        }
    }

    private func didTapStartChecklistsButton() {
        delegate?.showChecklistsInspection(items: items)
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ChecklistsTableCell.self), for: indexPath) as! ChecklistsTableCell
        cell.selectionStyle = .none

        let item = items[indexPath.row]
        cell.configure(title: item.type, subtitle: nil, isDeleteMode: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        delegate?.showChecklistsInspection(items: [item])
    }
}
