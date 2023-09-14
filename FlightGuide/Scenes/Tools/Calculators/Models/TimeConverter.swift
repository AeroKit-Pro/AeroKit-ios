//
//  TimeConverter.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 06.07.2023.
//

import Foundation

final class TimeConverter {
    
    let title = "Time Converter"
    
    private let secondsInput = TitledCalculatorInputFieldModel(title: "Seconds:")
    private let minutesInput = TitledCalculatorInputFieldModel(title: "Minutes:")
    private let hoursInput = TitledCalculatorInputFieldModel(title: "Hours:")
    
    private var seconds: Float?
    private var minutes: Float?
    private var hours: Float?
    
    init() {
        secondsInput.action = { [weak self] input in
            guard let self, let input, let seconds = Float(input) else { return }
            self.minutes = seconds / 60
            self.hours = seconds / 3600
            guard let minutes, let hours else { return }
            minutesInput.onBiderictionalEdtiting?(String(format: "%.2f", minutes))
            hoursInput.onBiderictionalEdtiting?(String(format: "%.2f", hours))
        }
        
        minutesInput.action = { [weak self] input in
            guard let self, let input, let minutes = Float(input) else { return }
            self.seconds = minutes * 60
            self.hours = minutes / 60
            guard let seconds, let hours else { return }
            secondsInput.onBiderictionalEdtiting?(String(format: "%.2f", seconds))
            hoursInput.onBiderictionalEdtiting?(String(format: "%.2f", hours))
        }
        
        hoursInput.action = { [weak self] input in
            guard let self, let input, let hours = Float(input) else { return }
            self.seconds = hours * 3600
            self.minutes = hours * 60
            guard let seconds, let minutes else { return }
            secondsInput.onBiderictionalEdtiting?(String(format: "%.2f", seconds))
            minutesInput.onBiderictionalEdtiting?(String(format: "%.2f", minutes))
        }
    }
    
}

extension TimeConverter: Calculator {
    var inputs: [TitledCalculatorInputFieldModel] {
        [secondsInput, minutesInput, hoursInput]
    }
    var outputs: [TitledCalculatorOutputModel] {
        []
    }
}
