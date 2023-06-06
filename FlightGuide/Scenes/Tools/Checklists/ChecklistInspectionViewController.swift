//
//  ChecklistInspectionViewController.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 7.06.23.
//

import UIKit

final class ChecklistInspectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = true
        tableView.register(ChecklistInspectionTableCell.self,
                           forCellReuseIdentifier: String(describing: ChecklistInspectionTableCell.self))
        return tableView
    }()

    private let buttonContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next checklist", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    weak var delegate: ChecklistsSelectionSceneDelegate?
    var companyNameWithModel: String?
    var items = [ChecklistWithItemsModel]()
    var onFinish: (() -> Void)?

    private var selectedCells: [Int] = []
    private var currentChecklistIndex = 0 {
        didSet {
            updateTitleAndNextButtonTitle()
        }
    }
    private var isFinishViewShown = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        updateTitleAndNextButtonTitle()

        nextButton.addAction(UIAction { [weak self] _ in self?.didTapNextButton() }, for: .touchUpInside)
    }

    private func updateTitleAndNextButtonTitle() {
        title = items[currentChecklistIndex].type
        nextButton.setTitle(items.count == currentChecklistIndex + 1 ? "Finish" : "Next checklist", for: .normal)
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
        buttonContainerView.addSubviews(nextButton)
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
        }
    }

    private func didTapNextButton() {
        if currentChecklistIndex + 1 != items.count {
            currentChecklistIndex += 1
            selectedCells = []
            tableView.reloadData()
        } else {
            if !isFinishViewShown {
                showFinishView()
            } else {
                onFinish?()
            }
        }
    }

    private func showFinishView() {
        title = nil
        let finishView = UIView()
        finishView.backgroundColor = .white
        view.addSubview(finishView)
        finishView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(buttonContainerView.snp.top)
        }

        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.text = "You have completed checklists, but the design of this screen isn't ready yet"
        label.textAlignment = .center
        finishView.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(50)
            make.centerY.equalToSuperview()
        }

        isFinishViewShown = true
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items[currentChecklistIndex].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ChecklistInspectionTableCell.self), for: indexPath) as! ChecklistInspectionTableCell
        cell.selectionStyle = .none
        let item = items[currentChecklistIndex].items[indexPath.row]

        cell.configure(title: item.name, value: item.value, isSelected: selectedCells.contains(indexPath.row))
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
