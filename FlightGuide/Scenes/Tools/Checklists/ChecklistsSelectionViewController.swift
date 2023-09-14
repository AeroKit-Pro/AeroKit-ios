//
//  ChecklistsSelectionViewController.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 7.06.23.
//

import UIKit
import FirebaseAuth
import RxSwift

protocol ChecklistsSelectionSceneDelegate: AnyObject {
    func showChecklistsInspection(items:  [ChecklistWithItemsModel])
}

final class ChecklistsSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let disposeBag = DisposeBag()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = true
        let tableHeaderView = ChecklistsTableHeaderView()
        tableHeaderView.configure(title: "Select \(companyNameWithModel ?? "") checklists:", underlinedText: companyNameWithModel)
        tableView.register(ChecklistSelectionTableCell.self, forCellReuseIdentifier: String(describing: ChecklistSelectionTableCell.self))

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

    private let addToLibraryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add to my library", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.hex(0xF1F1F1)
        button.layer.cornerRadius = 10
        return button
    }()

    @UserDataStorage(key: UserDefaultsKey.savedChecklists) private var savedChecklists: [ChecklistGroupStorageModel]?
    weak var delegate: ChecklistsSelectionSceneDelegate?
    var items = [ChecklistWithItemsModel]()
    var companyNameWithModel: String?
    var planeWithChecklistsModelId: Int?

    private var selectedCells: [Int] = [] {
        didSet {
            startChecklistsButton.setTitle(selectedCells.isEmpty ? "Start all checklists" : "Start selected checklists", for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Find checklists"
        setupLayout()
        startChecklistsButton.addAction(UIAction { [weak self] _ in self?.didTapStartChecklistsButton() }, for: .touchUpInside)
        addToLibraryButton.addAction(UIAction { [weak self] _ in self?.didTapAddToLibrary() }, for: .touchUpInside)

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
            make.height.equalTo(160)
        }
        buttonContainerView.addSubviews(startChecklistsButton, addToLibraryButton)
        addToLibraryButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.bottom.leading.trailing.equalToSuperview().inset(20)
        }
        startChecklistsButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(addToLibraryButton.snp.top).offset(-10)
        }
    }

    private func didTapStartChecklistsButton() {
        if !selectedCells.isEmpty {
            let selectedItems = selectedCells.map { items[$0] }
            delegate?.showChecklistsInspection(items: selectedItems)
        } else {
            delegate?.showChecklistsInspection(items: items)
        }
    }

    private func didTapAddToLibrary() {
        showSavingAlert { [weak self] name in
            guard let name = name, !name.isEmpty else { return }
            self?.saveGroup(name: name)
        }

        if !selectedCells.isEmpty {
            let selectedItems = selectedCells.map { items[$0] }
            delegate?.showChecklistsInspection(items: selectedItems)
        } else {
            delegate?.showChecklistsInspection(items: items)
        }

    }

    private func saveGroup(name: String) {
        let checklists: [ChecklistWithItemsModel] = {
            if !selectedCells.isEmpty {
                let selectedItems = selectedCells.map { items[$0] }
                return selectedItems
            }
            return items
        }()

        let model = ChecklistGroupStorageModel(id: planeWithChecklistsModelId!,
                                               date: Date(),
                                               name: name,
                                               fullPlaneName: companyNameWithModel ?? "",
                                               isFullChecklistModel: selectedCells.isEmpty,
                                               checklists: checklists)

        guard let userId = Auth.auth().currentUser?.uid else { return }

        APIClient().addUserChecklistsGroups(userId: userId,
                                            checklists: UserChecklistsGroupBase(name: name,
                                                                                checklists_ids: checklists.map { $0.id }))
        .subscribe { [weak self] event in
            switch event {
            case .next:
                if var savedChecklists = self?.savedChecklists {
                    savedChecklists.append(model)
                    self?.savedChecklists = savedChecklists
                } else {
                    self?.savedChecklists = [model]
                }
            case .error(let error):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Saving error", message: error.localizedDescription, preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Ok",
                                                  style: .default,
                                                  handler: nil))

                    self?.present(alert, animated: true, completion: nil)
                }
            default:
                break
            }
        }.disposed(by: self.disposeBag)
    }

    private func showSavingAlert(completionHandler: ((String?) -> Void)?) {
        let alert = UIAlertController(title: "Write name for checklist group:", message: nil, preferredStyle: .alert)
        alert.addTextField { [weak self] textField in
            textField.text = "My new checklist group for \(self?.companyNameWithModel ?? "")"
        }
        alert.addAction(UIAlertAction(title: "Save",
                                      style: .default,
                                      handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                return
            }
            completionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil))

        present(alert, animated: true, completion: nil)

    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ChecklistSelectionTableCell.self), for: indexPath) as! ChecklistSelectionTableCell
        cell.selectionStyle = .none

        let item = items[indexPath.row]

        if let index = selectedCells.firstIndex(of: indexPath.row) {
            cell.configure(title: item.type, selectionNumber: index + 1)
        } else {
            cell.configure(title: item.type, selectionNumber: nil)
        }

        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = selectedCells.firstIndex(of: indexPath.row) {
            selectedCells.remove(at: index)
            tableView.reloadData()
        } else {
            selectedCells.append(indexPath.row)
            tableView.reloadRows(at: [indexPath], with: .none)

        }
    }
}
