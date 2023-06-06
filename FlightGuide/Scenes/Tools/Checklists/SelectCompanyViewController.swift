//
//  SelectCompanyViewController.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 4.06.23.
//

import RxSwift
import UIKit

protocol SelectCompanySceneDelegate: AnyObject {
    func showPlaneSelection(model: CompanyWithPlanesModel)
}

final class SelectCompanyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let disposeBag = DisposeBag()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        let tableHeaderView = ChecklistsTableHeaderView()
        tableHeaderView.configure(title: "Select company:", underlinedText: nil)

        tableView.setSystemLayoutSizeFittingHeaderView(tableHeaderView)
        tableView.register(ChecklistsTableCell.self, forCellReuseIdentifier: String(describing: ChecklistsTableCell.self))
        return tableView
    }()

    private var items = [CompanyWithPlanesModel]() {
        didSet {
            tableView.reloadData()
        }
    }

    weak var delegate: SelectCompanySceneDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Find checklists"

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        APIClient().getChecklists().subscribe { event in
            switch event {
            case .next(let items):
                self.items = items
            default:
                break
            }
        }.disposed(by: disposeBag)
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ChecklistsTableCell.self), for: indexPath) as! ChecklistsTableCell
        cell.selectionStyle = .none

        let item = items[indexPath.row]
        cell.configure(title: item.name, subtitle: nil, isDeleteMode: false)

        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.showPlaneSelection(model: items[indexPath.row])

    }
}
