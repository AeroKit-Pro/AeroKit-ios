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
    let maskedCorners: CACornerMask
    
    init(with message: Message) {
        self.role = message.role
        self.message = message.content
        self.createdAt = message.createdAt
        
        switch message.role {
        case .user:
            backgroundColor = .flg_light_blue
            maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
        case .assistant:
            backgroundColor = .flg_light_gray
            maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
        default:
            backgroundColor = nil
            maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
        }
    }
}
