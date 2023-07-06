//
//  FlightTimeGroundSpeedCalculator.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 06.07.2023.
//

import Foundation

final class FlightTimeGroundSpeedCalculator {
    
    let title = "Flight Time For Distance & Ground Speed"
    
    private let distanceInput = TitledCalculatorInputFieldModel(title: "Distance:")
    private let groundSpeedInput = TitledCalculatorInputFieldModel(title: "Ground Speed:")
    
    private let flightTimeOutput = TitledCalculatorOutputModel(title: "Flight Time:")

    private var distance: Float?
    private var groundSpeed: Float?
    
    init() {
        distanceInput.action = { [weak self] input in
            guard let self, let input else { return }
            self.distance = Float(input)
            self.calculate()
        }
        
        groundSpeedInput.action = { [weak self] input in
            guard let self, let input else { return }
            self.groundSpeed = Float(input)
            self.calculate()
        }
    }
    
    private func calculate() {
        guard let distance, let groundSpeed else {
            flightTimeOutput.action?("")
            return
        }
        let flightTime = (distance / groundSpeed).toTimeString()
        flightTimeOutput.action?(flightTime)
    }
    
}

extension FlightTimeGroundSpeedCalculator: Calculator {
    var inputs: [TitledCalculatorInputFieldModel] {
        [distanceInput, groundSpeedInput]
    }
    var outputs: [TitledCalculatorOutputModel] {
        [flightTimeOutput]
    }
}

