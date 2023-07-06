//
//  HeadingWindCorrectionAngleCalculator.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 04.07.2023.
//

import Foundation

final class HeadingWindCorrectionAngleCalculator {
    
    let title = "Heading, Ground Speed & Wind Correction Angle"
    
    private let courseInput = TitledCalculatorInputFieldModel(title: "Course:")
    private let trueAirSpeedInput = TitledCalculatorInputFieldModel(title: "True Air Speed:")
    private let windDirectionInput = TitledCalculatorInputFieldModel(title: "Wind Direction:")
    private let windSpeedInput = TitledCalculatorInputFieldModel(title: "Wind Speed:")
    
    private let windCorrectionAngleOutput = TitledCalculatorOutputModel(title: "Wind C Angle:")
    private let headingOutput = TitledCalculatorOutputModel(title: "Heading:")
    
    private var course: Float?
    private var trueAirSpeed: Float?
    private var windDirection: Float?
    private var windSpeed: Float?
    
    init() {
        courseInput.action = { [weak self] input in
            guard let self, let input else { return }
            self.course = Float(input)
            self.calculate()
        }
        
        trueAirSpeedInput.action = { [weak self] input in
            guard let self, let input else { return }
            self.trueAirSpeed = Float(input)
            self.calculate()
        }
        
        windDirectionInput.action = { [weak self] input in
            guard let self, let input else { return }
            self.windDirection = Float(input)
            self.calculate()
        }
        
        windSpeedInput.action = { [weak self] input in
            guard let self, let input else { return }
            self.windSpeed = Float(input)
            self.calculate()
        }
    }
    
    private func calculate() {
        guard let course, let trueAirSpeed, let windDirection, let windSpeed else {
            windCorrectionAngleOutput.action?("")
            headingOutput.action?("")
            return
        }
        
        let courseRadians = course.degreesToRadians()
        let windDirectionRadians = windDirection.degreesToRadians()
        
        let windCorrectionAngleRadians = asin(windSpeed * sin(windDirectionRadians - courseRadians) / trueAirSpeed)
        let headingRadians = courseRadians + windCorrectionAngleRadians
        
        let windCorrectionAngle = windCorrectionAngleRadians.radiansToDegrees()
        let heading = headingRadians.radiansToDegrees()
        
        windCorrectionAngleOutput.action?(String(format: "%.3f", windCorrectionAngle))
        headingOutput.action?(String(format: "%.3f", heading))
    }
    
}

extension HeadingWindCorrectionAngleCalculator: Calculator {
    var inputs: [TitledCalculatorInputFieldModel] {
        [courseInput, trueAirSpeedInput, windDirectionInput, windSpeedInput]
    }
    var outputs: [TitledCalculatorOutputModel] {
        [windCorrectionAngleOutput, headingOutput]
    }
}
