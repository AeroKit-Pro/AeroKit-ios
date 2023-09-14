//
//  SpeedConverter.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 06.07.2023.
//

import Foundation

final class SpeedConverter {
    
    let title = "Speed Converter"
    
    private let knotsInput = TitledCalculatorInputFieldModel(title: "Knots:")
    private let machNumber = TitledCalculatorInputFieldModel(title: "Mach Number at SL:")
    private let milesPerHourInput = TitledCalculatorInputFieldModel(title: "Miles per hour:")
    private let kilometersInput = TitledCalculatorInputFieldModel(title: "Kilometers per hour:")
    private let feetPerMinuteInput = TitledCalculatorInputFieldModel(title: "Feet per minute:")
    private let metersPerSecondInput = TitledCalculatorInputFieldModel(title: "Meters per second:")
    
    private var knots: Float?
    private var machs: Float?
    private var miles: Float?
    private var kilometers: Float?
    private var feet: Float?
    private var meters: Float?
    
    init() {
        knotsInput.action = { [weak self] input in
            guard let self, let input, let knots = Float(input) else { return }
            self.machs = knots * 0.0015
            self.miles = knots * 1.151
            self.kilometers = knots * 1.852
            self.feet = knots * 101.2686
            self.meters = knots * 0.5144
            guard let machs, let miles, let kilometers, let feet, let meters else { return }
            machNumber.onBiderictionalEdtiting?(String(format: "%.2f", machs))
            milesPerHourInput.onBiderictionalEdtiting?(String(format: "%.2f", miles))
            kilometersInput.onBiderictionalEdtiting?(String(format: "%.2f", kilometers))
            feetPerMinuteInput.onBiderictionalEdtiting?(String(format: "%.2f", feet))
            metersPerSecondInput.onBiderictionalEdtiting?(String(format: "%.2f", meters))
        }
        
        machNumber.action = { [weak self] input in
            guard let self, let input, let machs = Float(input) else { return }
            self.knots = machs * 661.478
            self.miles = machs * 761.2157
            self.kilometers = machs * 1225.0573
            self.feet = machs * 66986.9487
            self.meters = machs * 340.2941
            guard let knots, let miles, let kilometers, let feet, let meters else { return }
            knotsInput.onBiderictionalEdtiting?(String(format: "%.2f", knots))
            milesPerHourInput.onBiderictionalEdtiting?(String(format: "%.2f", miles))
            kilometersInput.onBiderictionalEdtiting?(String(format: "%.2f", kilometers))
            feetPerMinuteInput.onBiderictionalEdtiting?(String(format: "%.2f", feet))
            metersPerSecondInput.onBiderictionalEdtiting?(String(format: "%.2f", meters))
        }
        
        milesPerHourInput.action = { [weak self] input in
            guard let self, let input, let miles = Float(input) else { return }
            self.knots = miles * 0.869
            self.machs = miles * 0.0013
            self.kilometers = miles * 1.6093
            self.feet = miles * 88
            self.meters = miles * 0.447
            guard let knots, let machs, let feet, let meters else { return }
            knotsInput.onBiderictionalEdtiting?(String(format: "%.2f", knots))
            machNumber.onBiderictionalEdtiting?(String(format: "%.2f", machs))
            kilometersInput.onBiderictionalEdtiting?(String(format: "%.2f", miles))
            feetPerMinuteInput.onBiderictionalEdtiting?(String(format: "%.2f", feet))
            metersPerSecondInput.onBiderictionalEdtiting?(String(format: "%.2f", meters))
        }
        
        kilometersInput.action = { [weak self] input in
            guard let self, let input, let kilometers = Float(input) else { return }
            self.knots = kilometers * 0.54
            self.machs = kilometers * 0.0008
            self.miles = kilometers * 0.6214
            self.feet = kilometers * 54.6807
            self.meters = kilometers * 0.2778
            guard let knots, let machs, let miles, let feet else { return }
            knotsInput.onBiderictionalEdtiting?(String(format: "%.2f", knots))
            machNumber.onBiderictionalEdtiting?(String(format: "%.2f", machs))
            milesPerHourInput.onBiderictionalEdtiting?(String(format: "%.2f", miles))
            feetPerMinuteInput.onBiderictionalEdtiting?(String(format: "%.2f", feet))
            metersPerSecondInput.onBiderictionalEdtiting?(String(format: "%.2f", kilometers))
        }
        
        feetPerMinuteInput.action = { [weak self] input in
            guard let self, let input, let feet = Float(input) else { return }
            self.knots = feet * 0.0099
            self.machs = feet * 0.00001493
            self.miles = feet * 0.0114
            self.kilometers = feet * 0.0183
            self.meters = feet * 0.0051
            guard let knots, let machs, let miles, let kilometers, let meters else { return }
            knotsInput.onBiderictionalEdtiting?(String(format: "%.2f", knots))
            machNumber.onBiderictionalEdtiting?(String(format: "%.2f", machs))
            milesPerHourInput.onBiderictionalEdtiting?(String(format: "%.2f", miles))
            kilometersInput.onBiderictionalEdtiting?(String(format: "%.2f", kilometers))
            metersPerSecondInput.onBiderictionalEdtiting?(String(format: "%.2f", meters))
        }
        
        metersPerSecondInput.action = { [weak self] input in
            guard let self, let input, let meters = Float(input) else { return }
            self.knots = meters * 1.9438
            self.machs = meters * 0.0029
            self.miles = meters * 2.2369
            self.kilometers = meters * 3.6
            self.feet = meters * 196.8502
            guard let knots, let machs, let miles, let kilometers, let feet else { return }
            knotsInput.onBiderictionalEdtiting?(String(format: "%.2f", knots))
            machNumber.onBiderictionalEdtiting?(String(format: "%.2f", machs))
            milesPerHourInput.onBiderictionalEdtiting?(String(format: "%.2f", miles))
            kilometersInput.onBiderictionalEdtiting?(String(format: "%.2f", kilometers))
            feetPerMinuteInput.onBiderictionalEdtiting?(String(format: "%.2f", feet))
        }
    }
    
}

extension SpeedConverter: Calculator {
    var inputs: [TitledCalculatorInputFieldModel] {
        [knotsInput, machNumber, milesPerHourInput, kilometersInput, feetPerMinuteInput, metersPerSecondInput]
    }
    var outputs: [TitledCalculatorOutputModel] {
        []
    }
}
