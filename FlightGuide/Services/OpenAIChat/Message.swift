//
//  Message.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 18.06.2023.
//

import Foundation

enum Role: String, Codable {
    case system
    case user
    case assistant
}

struct Message: Codable {
    let id: String
    let role: Role
    let createdAt: String
    var content: String
    
    static var defaultSystemMessage: Message {
        Message(role: .system,
                content: "You are a pilot's assistant trained on aircraft operating instructions, checklists, legislative norms in the field of aviation, books for pilots, safety reports and crash reports. You can give short and clear answers to questions exclusively on the topics of aviation, airplanes, piloting, troubleshooting in an airplane, preventing plane crashes and giving pilots brief step-by-step instructions in case of danger during piloting.")
    }
    
    init(id: String = UUID().uuidString, role: Role, content: String, createdAt: Date? = nil) {
        self.id = id
        self.role = role
        self.content = content
        self.createdAt = Date().localisedTime
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(role.rawValue, forKey: .role)
        try container.encode(content, forKey: .content)
    }
}
