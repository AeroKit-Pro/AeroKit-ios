//
//  TrueAirSpeedCalculator.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 06.07.2023.
//

import Foundation

final class TrueAirSpeedCalculator {
    
    let title = "True Air Speed Calculator"
    
    private let pressureAltitudeInput = TitledCalculatorInputFieldModel(title: "Pressure Altitude (feet):")
    private let outsideAirTempInput = TitledCalculatorInputFieldModel(title: "Outside Air Temp. (°C):")
    private let airSpeedInput = TitledCalculatorInputFieldModel(title: "Ind. Air Speed (knot):")
    
    private let trueAirSpeedOutput = TitledCalculatorOutputModel(title: "True Air Speed (knot):")

    private var pressureAltitude: Float?
    private var outsideAirTemp: Float?
    private var airSpeed: Float?
    
    init() {
        pressureAltitudeInput.action = { [weak self] input in
            guard let self, let input else { return }
            self.pressureAltitude = Float(input)
            self.calculate()
        }
        
        outsideAirTempInput.action = { [weak self] input in
            guard let self, let input else { return }
            self.outsideAirTemp = Float(input)
            self.calculate()
        }
        
        airSpeedInput.action = { [weak self] input in
            guard let self, let input else { return }
            self.airSpeed = Float(input)
            self.calculate()
        }
    }
    
    private func calculate() {
        guard let pressureAltitude, let outsideAirTemp, let airSpeed else {
            trueAirSpeedOutput.action?("")
            return
        }
        let isaTemperature: Float = 15
        let temperatureDeviation: Float = (outsideAirTemp - isaTemperature)
        let temperatureCorrection: Float = 1 + (temperatureDeviation / 100)
        
        let pressureAltitudeCorrection: Float = (1 + (pressureAltitude / 1000) / 100)
        
        let trueAirspeed: Float = airSpeed * temperatureCorrection * pressureAltitudeCorrection
        
        trueAirSpeedOutput.action?(String(format: "%.2f", trueAirspeed))
    }
    
}

extension TrueAirSpeedCalculator: Calculator {
    var inputs: [TitledCalculatorInputFieldModel] {
        [pressureAltitudeInput, outsideAirTempInput, airSpeedInput]
    }
    var outputs: [TitledCalculatorOutputModel] {
        [trueAirSpeedOutput]
    }
}
