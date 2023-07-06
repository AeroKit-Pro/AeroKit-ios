//
//  FuelConsumptionForFlightTimeCalculator.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 06.07.2023.
//

import Foundation

final class FuelConsumptionForFlightTimeCalculator {
    
    let title = "Fuel Consumption For Flight Time"
    
    private let flightTimeInput = TitledCalculatorInputFieldModel(title: "Flight Time (min):")
    private let fuelPerHourInput = TitledCalculatorInputFieldModel(title: "Fuel per Hour:")
    
    private let requiredFuelOutput = TitledCalculatorOutputModel(title: "Required Fuel:")

    private var flightTime: Float?
    private var fuelPerHour: Float?
    
    init() {
        flightTimeInput.action = { [weak self] input in
            guard let self, let input else { return }
            self.flightTime = Float(input)
            self.calculate()
        }
        
        fuelPerHourInput.action = { [weak self] input in
            guard let self, let input else { return }
            self.fuelPerHour = Float(input)
            self.calculate()
        }
    }
    
    private func calculate() {
        guard let flightTime, let fuelPerHour else {
            requiredFuelOutput.action?("")
            return
        }
        let hours = flightTime / 60
        let fuelRequired = fuelPerHour * hours
        requiredFuelOutput.action?(String(format: "%.2f", fuelRequired))
    }
    
}

extension FuelConsumptionForFlightTimeCalculator: Calculator {
    var inputs: [TitledCalculatorInputFieldModel] {
        [flightTimeInput, fuelPerHourInput]
    }
    var outputs: [TitledCalculatorOutputModel] {
        [requiredFuelOutput]
    }
}

