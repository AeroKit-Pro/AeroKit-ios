//
//  TitledCalculatorInputField.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 03.07.2023.
//

final class TitledCalculatorInputFieldModel {
    let title: String
    var action: ((String?) -> Void)?
    var onBiderictionalEdtiting: ((String?) -> Void)?
    
    init(title: String) {
        self.title = title
    }
}
