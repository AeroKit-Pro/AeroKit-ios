//
//  ChecklistsViewController.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 1.06.23.
//

import UIKit
import RxSwift

protocol ChecklistsViewInterface: AnyObject {
    func updateState(_ state: ChecklistsViewController.State)
}

final class ChecklistsViewController: UIViewController {
    enum State: Equatable {
        case empty
        case data(items: [ChecklistGroupStorageModel])
        case edit
    }

    private let emptyView = ChecklistsEmptyView()
    private let findButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.hex(0x333333)
        button.setTitle("Find official checklists", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.layer.cornerRadius = 10
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(ChecklistsTableCell.self, forCellReuseIdentifier: String(describing: ChecklistsTableCell.self))
        let tableHeaderView = ChecklistsTableHeaderView()
        tableHeaderView.configure(title: "Select your checklists:", underlinedText: nil)
        tableView.setSystemLayoutSizeFittingHeaderView(tableHeaderView)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    private let rightBarButton = UIButton()

    var viewModel: ChecklistsViewModelInterface?
    private var state = State.empty
    private var items = [ChecklistGroupStorageModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Checklists"

        setupLayout()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.onViewWillAppear()
    }

    private func setupLayout() {
        view.addSubviews(tableView, emptyView, findButton)
        findButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }

        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(findButton.snp.top)
        }

        emptyView.snp.makeConstraints { make in
            make.edges.equalTo(tableView)
        }
    }

    private func setupUI() {
        findButton.addAction(UIAction(handler: { [weak self] _ in self?.viewModel?.onTapFindButton() }), for: .touchUpInside)
        rightBarButton.addAction(UIAction(handler: { [weak self] _ in self?.viewModel?.onTapEdit() }), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
    }

    func updateRightBarButton() {
        let attributesRightBarButton: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributeString = NSMutableAttributedString(
            string: state == .edit ? "Cancel" : "Edit",
            attributes: attributesRightBarButton
        )
        rightBarButton.setAttributedTitle(attributeString, for: .normal)
        rightBarButton.sizeToFit()
    }

    @objc
    private func didTapRemoveButton(sender: UIButton) {
        let item = items[sender.tag]
        showDeleteConfirmationAlert(name: item.name) { [weak self] in
            self?.viewModel?.onDelete(item: item)
        }
    }

    private func showDeleteConfirmationAlert(name: String, completionHandler: (() -> Void)?) {
        let alert = UIAlertController(title: "Are you sure you want to delete \(name)", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete",
                                      style: .destructive,
                                      handler: { (action:UIAlertAction) in
            completionHandler?()
        }))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ChecklistsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ChecklistsTableCell.self), for: indexPath) as! ChecklistsTableCell
        cell.selectionStyle = .none

        let item = items[indexPath.row]
        cell.configure(title: item.name, subtitle: item.fullPlaneName, isDeleteMode: state == .edit)

        cell.removeButton.tag = indexPath.row
        cell.removeButton.addTarget(self, action: #selector(didTapRemoveButton), for: .touchUpInside)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        viewModel?.onSelect(item: item)
    }
}

// MARK: - ChecklistsViewInterface
extension ChecklistsViewController: ChecklistsViewInterface {
    func updateState(_ state: State) {
        self.state = state
        updateRightBarButton()
        switch state {
        case .data(let items):
            emptyView.isHidden = true
            rightBarButton.isHidden = false
            self.items = items
            tableView.reloadData()

        case .empty:
            rightBarButton.isHidden = true
            emptyView.isHidden = false
        case .edit:
            tableView.reloadData()
        }
    }

}
