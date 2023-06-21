//
//  MessageCellViewModel.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 11.06.2023.
//

import UIKit

struct MessageCellViewModel {
    let role: Role
    let message: String
    let createdAt: String
    let backgroundColor: UIColor?
    
    init(with message: Message) {
        self.role = message.role
        self.message = message.content
        self.createdAt = message.createdAt
        
        switch message.role {
        case .user: backgroundColor = .flg_light_blue
        case .assistant: backgroundColor = .flg_light_gray
        default: backgroundColor = nil
        }
    }
}
