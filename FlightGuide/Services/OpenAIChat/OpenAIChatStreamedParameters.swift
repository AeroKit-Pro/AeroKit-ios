//
//  OpenAIChatParameters.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 17.06.2023.
//

import Foundation

protocol DataConvertible: Codable {
    func asData() -> Data?
}

struct OpenAIChatStreamedParameters {
    var temperature: Float
    let stream: Bool = true
    let maxTokens: Int?
    let presencePenalty: Float
    let frequencyPenalty: Float
    let user: String?
    var messages: [Message]
    
    private let temperatureAuthorizedRange: ClosedRange<Float> = 0...2
    private let presencePenaltyAuthorizedRange: ClosedRange<Float> = -2...2
    private let frequencyPenaltyAuthorizedRange: ClosedRange<Float> = -2...2
    
    static var `default`: OpenAIChatStreamedParameters {
        OpenAIChatStreamedParameters()
    }
    
    init(temperature: Float = 0.7,
         maxTokens: Int? = nil,
         presencePenalty: Float = 0,
         frequencyPenalty: Float = 0,
         user: String? = nil,
         messages: [Message] = [Message.defaultSystemMessage]) {
        assert(temperatureAuthorizedRange.contains(temperature))
        assert(presencePenaltyAuthorizedRange.contains(presencePenalty))
        assert(frequencyPenaltyAuthorizedRange.contains(frequencyPenalty))
        self.temperature = temperature
        self.maxTokens = maxTokens
        self.presencePenalty = presencePenalty
        self.frequencyPenalty = frequencyPenalty
        self.user = user
        self.messages = messages
    }
}

extension OpenAIChatStreamedParameters: DataConvertible {
    func asData() -> Data? {
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(self)
        
        return jsonData
    }
    
    enum CodingKeys: String, CodingKey {
        case temperature
        case stream
        case maxTokens = "max_tokens"
        case presencePenalty = "presence_penalty"
        case frequencyPenalty = "frequency_penalty"
        case user
        case messages
    }
}
