//
//  SettingsView.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 5.07.23.
//

import UIKit
import FirebaseAuth

enum SettingItem: CaseIterable {
    case account
    case aboutUs

    var title: String {
        switch self {
        case .account:
            return "Account"
        case .aboutUs:
            return "About us"
        }
    }

    var subtitle: String {
        switch self {
        case .account:
            return "Email: \(FirebaseAuth.Auth.auth().currentUser?.email ?? "")"
        case .aboutUs:
            return "App info, developers, our website, etc."
        }
    }

    var image: UIImage? {
        switch self {
        case .account:
            return UIImage(named: "settings_account")
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

    let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Logout", for: .normal)
        let color = UIColor.hex(0xE32636)
        button.setTitleColor(color, for: .normal)
        button.backgroundColor = color.withAlphaComponent(0.25)
        button.layer.cornerRadius = 10
        return button
    }()

    private var items = SettingItem.allCases
    var onTapItem: ((SettingItem) -> Void)?
    init() {
        super.init(frame: .zero)
        setupLayout()
        setupUI()
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

        addSubview(logoutButton)
        logoutButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(25)
            make.height.equalTo(40)
        }
    }

    private func setupUI() {
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
