//
//  SelectPlaneViewController.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 1.06.23.
//

import UIKit

protocol SelectPlaneSceneDelegate: AnyObject {
    func showChecklistSelection(model: PlaneWithChecklistsModel, companyNameWithModel: String)
}

final class SelectPlaneViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    private let tableHeaderView = ChecklistsTableHeaderView()

    var items = [PlaneWithChecklistsModel]()

    private var selectedCells: [Int] = []
    var companyName: String?
    weak var delegate: SelectPlaneSceneDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Find checklists"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableHeaderView.configure(title:  "Select \(companyName ?? "") plane model:", underlinedText: companyName)
        tableView.register(ChecklistsTableCell.self, forCellReuseIdentifier: String(describing: ChecklistsTableCell.self))

        tableView.setSystemLayoutSizeFittingHeaderView(tableHeaderView)
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ChecklistsTableCell.self), for: indexPath) as! ChecklistsTableCell
        cell.selectionStyle = .none
        let item = items[indexPath.row]
        cell.configure(title: item.model, subtitle: nil, isDeleteMode: false)
        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let companyNameWithModel = "\(companyName ?? "") \(item.model)"
        delegate?.showChecklistSelection(model: item, companyNameWithModel: companyNameWithModel)
    }
}
