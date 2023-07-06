//
//  TitledCalculatorOutputModel.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 06.07.2023.
//

final class TitledCalculatorOutputModel {
    let title: String
    var action: ((String) -> Void)?
    
    init(title: String) {
        self.title = title
    }
}
