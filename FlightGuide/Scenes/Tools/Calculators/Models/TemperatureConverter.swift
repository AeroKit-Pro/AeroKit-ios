//
//  TemperatureConverter.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 06.07.2023.
//

import Foundation

final class TemperatureConverter {
    
    let title = "Temperature Converter"
    
    private let fahrenheitInput = TitledCalculatorInputFieldModel(title: "Fahrenheit:")
    private let celsiusInput = TitledCalculatorInputFieldModel(title: "Celsius:")
    private let kelvinInput = TitledCalculatorInputFieldModel(title: "Kelvin:")
    
    private var fahrenheit: Float?
    private var celsius: Float?
    private var kelvin: Float?
    
    init() {
        fahrenheitInput.action = { [weak self] input in
            guard let self, let input, let fahrenheit = Float(input) else { return }
            self.celsius = (fahrenheit - 32) / 1.8
            self.kelvin = (fahrenheit - 32) * (5 / 9) + 273.15
            guard let celsius, let kelvin else { return }
            celsiusInput.onBiderictionalEdtiting?(String(format: "%.2f", celsius))
            kelvinInput.onBiderictionalEdtiting?(String(format: "%.2f", kelvin))
        }
        
        celsiusInput.action = { [weak self] input in
            guard let self, let input, let celsius = Float(input) else { return }
            self.fahrenheit = celsius * (9/5) + 32
            self.kelvin = celsius + 273.15
            guard let fahrenheit, let kelvin else { return }
            fahrenheitInput.onBiderictionalEdtiting?(String(format: "%.2f", fahrenheit))
            kelvinInput.onBiderictionalEdtiting?(String(format: "%.2f", kelvin))
        }
        
        kelvinInput.action = { [weak self] input in
            guard let self, let input, let kelvin = Float(input) else { return }
            self.fahrenheit = (kelvin - 273.15) * (9/5) + 32
            self.celsius = kelvin - 273.15
            guard let fahrenheit, let celsius else { return }
            fahrenheitInput.onBiderictionalEdtiting?(String(format: "%.2f", fahrenheit))
            celsiusInput.onBiderictionalEdtiting?(String(format: "%.2f", celsius))
        }
    }
    
}

extension TemperatureConverter: Calculator {
    var inputs: [TitledCalculatorInputFieldModel] {
        [fahrenheitInput, celsiusInput, kelvinInput]
    }
    var outputs: [TitledCalculatorOutputModel] {
        []
    }
}
