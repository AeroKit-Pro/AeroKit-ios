//
//  DistanceConverter.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 06.07.2023.
//

import Foundation

final class DistanceConverter {
    
    let title = "Distance Converter"
    
    private let nauticalMilesInput = TitledCalculatorInputFieldModel(title: "Nautical Miles:")
    private let statuteMilesInput = TitledCalculatorInputFieldModel(title: "Statute Miles:")
    private let kilometersInput = TitledCalculatorInputFieldModel(title: "Kilometers:")
    private let metersInput = TitledCalculatorInputFieldModel(title: "Meters:")
    private let feetInput = TitledCalculatorInputFieldModel(title: "Feet:")
    private let yardsInput = TitledCalculatorInputFieldModel(title: "Yards:")
    
    private var nauticalMiles: Float?
    private var statuteMiles: Float?
    private var kilometers: Float?
    private var meters: Float?
    private var feet: Float?
    private var yards: Float?
    
    init() {
        nauticalMilesInput.action = { [weak self] input in
            guard let self, let input, let nauticalMiles = Float(input) else { return }
            self.statuteMiles = nauticalMiles * 1.151
            self.kilometers = nauticalMiles * 1.852
            self.meters = nauticalMiles * 1852
            self.feet = nauticalMiles * 6076
            self.yards = nauticalMiles * 2025
            guard let statuteMiles, let kilometers, let meters, let feet, let yards else { return }
            statuteMilesInput.onBiderictionalEdtiting?(String(format: "%.2f", statuteMiles))
            kilometersInput.onBiderictionalEdtiting?(String(format: "%.2f", kilometers))
            metersInput.onBiderictionalEdtiting?(String(format: "%.2f", meters))
            feetInput.onBiderictionalEdtiting?(String(format: "%.2f", feet))
            yardsInput.onBiderictionalEdtiting?(String(format: "%.2f", yards))
        }
        
        statuteMilesInput.action = { [weak self] input in
            guard let self, let input, let statuteMiles = Float(input) else { return }
            self.nauticalMiles = statuteMiles / 1.151
            self.kilometers = statuteMiles * 1.609
            self.meters = statuteMiles * 1609
            self.feet = statuteMiles * 5280
            self.yards = statuteMiles * 1760
            guard let nauticalMiles, let kilometers, let meters, let feet, let yards else { return }
            nauticalMilesInput.onBiderictionalEdtiting?(String(format: "%.2f", nauticalMiles))
            kilometersInput.onBiderictionalEdtiting?(String(format: "%.2f", kilometers))
            metersInput.onBiderictionalEdtiting?(String(format: "%.2f", meters))
            feetInput.onBiderictionalEdtiting?(String(format: "%.2f", feet))
            yardsInput.onBiderictionalEdtiting?(String(format: "%.2f", yards))
        }
        
        kilometersInput.action = { [weak self] input in
            guard let self, let input, let kilometers = Float(input) else { return }
            self.nauticalMiles = kilometers / 1.852
            self.statuteMiles = kilometers / 1.609
            self.meters = kilometers * 1000
            self.feet = kilometers * 3281
            self.yards = kilometers * 1094
            guard let nauticalMiles, let statuteMiles, let meters, let feet, let yards else { return }
            nauticalMilesInput.onBiderictionalEdtiting?(String(format: "%.2f", nauticalMiles))
            statuteMilesInput.onBiderictionalEdtiting?(String(format: "%.2f", statuteMiles))
            metersInput.onBiderictionalEdtiting?(String(format: "%.2f", meters))
            feetInput.onBiderictionalEdtiting?(String(format: "%.2f", feet))
            yardsInput.onBiderictionalEdtiting?(String(format: "%.2f", yards))
        }
        
        metersInput.action = { [weak self] input in
            guard let self, let input, let meters = Float(input) else { return }
            self.nauticalMiles = meters / 1852
            self.statuteMiles = meters / 1609
            self.kilometers = meters / 1000
            self.feet = meters * 3.281
            self.yards = meters * 1.094
            guard let nauticalMiles, let statuteMiles, let kilometers, let feet, let yards else { return }
            nauticalMilesInput.onBiderictionalEdtiting?(String(format: "%.2f", nauticalMiles))
            statuteMilesInput.onBiderictionalEdtiting?(String(format: "%.2f", statuteMiles))
            kilometersInput.onBiderictionalEdtiting?(String(format: "%.2f", kilometers))
            feetInput.onBiderictionalEdtiting?(String(format: "%.2f", feet))
            yardsInput.onBiderictionalEdtiting?(String(format: "%.2f", yards))
        }
        
        feetInput.action = { [weak self] input in
            guard let self, let input, let feet = Float(input) else { return }
            self.nauticalMiles = feet / 6076
            self.statuteMiles = feet / 5280
            self.kilometers = feet / 3281
            self.meters = feet / 3.281
            self.yards = feet / 3
            guard let nauticalMiles, let statuteMiles, let kilometers, let meters, let yards else { return }
            nauticalMilesInput.onBiderictionalEdtiting?(String(format: "%.2f", nauticalMiles))
            statuteMilesInput.onBiderictionalEdtiting?(String(format: "%.2f", statuteMiles))
            kilometersInput.onBiderictionalEdtiting?(String(format: "%.2f", kilometers))
            metersInput.onBiderictionalEdtiting?(String(format: "%.2f", meters))
            yardsInput.onBiderictionalEdtiting?(String(format: "%.2f", yards))
        }
        
        yardsInput.action = { [weak self] input in
            guard let self, let input, let yards = Float(input) else { return }
            self.nauticalMiles = yards / 2025
            self.statuteMiles = yards / 1760
            self.kilometers = yards / 1094
            self.meters = yards / 1.094
            self.feet = yards * 3
            guard let nauticalMiles, let statuteMiles, let kilometers, let meters, let feet else { return }
            nauticalMilesInput.onBiderictionalEdtiting?(String(format: "%.2f", nauticalMiles))
            statuteMilesInput.onBiderictionalEdtiting?(String(format: "%.2f", statuteMiles))
            kilometersInput.onBiderictionalEdtiting?(String(format: "%.2f", kilometers))
            metersInput.onBiderictionalEdtiting?(String(format: "%.2f", meters))
            feetInput.onBiderictionalEdtiting?(String(format: "%.2f", feet))
        }
    }
    
}

extension DistanceConverter: Calculator {
    var inputs: [TitledCalculatorInputFieldModel] {
        [nauticalMilesInput, statuteMilesInput, kilometersInput, metersInput, feetInput, yardsInput]
    }
    var outputs: [TitledCalculatorOutputModel] {
        []
    }
}
