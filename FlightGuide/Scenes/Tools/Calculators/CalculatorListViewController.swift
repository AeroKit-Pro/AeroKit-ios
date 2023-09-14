//
//  CalculatorListViewController.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 06.07.2023.
//

import UIKit

protocol CalculatorListOutput: AnyObject {
    func showCalculator(model: Calculator)
}

final class CalculatorListViewController: UIViewController {
    
    weak var output: CalculatorListOutput?
        
    private let tableView = UITableView()
    private let dataSource = CalculatorsDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = dataSource
        setupAppearance()
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupAppearance() {
        view.backgroundColor = .white
        tableView.separatorStyle = .none
    }
    
}

extension CalculatorListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = dataSource.object(for: indexPath) else { return }
        output?.showCalculator(model: model)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        switch section {
        case 0: label.text = "Main aviation calculators"
        case 1: label.text = "Unit Converters"
        default: break
        }
        return label
    }
}
