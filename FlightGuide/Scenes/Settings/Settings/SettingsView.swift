//
//  SettingsView.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 5.07.23.
//

import UIKit
import FirebaseAuth

enum SettingItem: CaseIterable {
    case aboutUs

    var title: String {
        switch self {
        case .aboutUs:
            return "About us"
        }
    }

    var subtitle: String {
        switch self {
        case .aboutUs:
            return "App info, developers, our website, etc."
        }
    }

    var image: UIImage? {
        switch self {
        case .aboutUs:
            return UIImage(named: "settings_aboutUs")
        }
    }
}

final class SettingsView: UIView {
    private lazy var tableView: AutoSizingTableView = {
        let tableView = AutoSizingTableView()
        tableView.separatorStyle = .none
        tableView.register(SettingsTableCell.self, forCellReuseIdentifier: String(describing: SettingsTableCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    private var items = SettingItem.allCases
    var onTapItem: ((SettingItem) -> Void)?
    init() {
        super.init(frame: .zero)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
        }
    }
}

extension SettingsView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SettingsTableCell.self), for: indexPath) as! SettingsTableCell
        cell.selectionStyle = .none

        let item = items[indexPath.row]
        cell.configure(title: item.title, subtitle: item.subtitle, image: item.image)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onTapItem?(items[indexPath.row])
    }
}
