//
//  CalculatorViewController.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 02.07.2023.
//

import UIKit

protocol Calculator {
    var title: String { get }
    var inputs: [TitledCalculatorInputFieldModel] { get }
    var outputs: [TitledCalculatorOutputModel] { get }
}

final class CalculatorViewController: UIViewController {
    
    var model: Calculator?
    var calculatorView: CalculatorView?
    
    override func loadView() {
        guard let model else { return }
        calculatorView = CalculatorView(with: model)
        view = calculatorView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        calculatorView?.becomeResponder()
    }
    
}
