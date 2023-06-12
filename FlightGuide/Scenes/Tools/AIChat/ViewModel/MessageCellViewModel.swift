//
//  MessageCellViewModel.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 11.06.2023.
//

struct MessageCellViewModel {
    let message: String
    let time: String
    
    init(message: String, time: String) {
        self.message = message
        self.time = time
    }
}
