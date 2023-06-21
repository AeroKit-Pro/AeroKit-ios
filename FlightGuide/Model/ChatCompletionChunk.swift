//
//  ChatCompletionChunk.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 19.06.2023.
//

struct ChatCompletionChunk: Codable {
    let id: String
    let choices: [Choice]
}

struct Choice: Codable {
    let finishReason: String?
    let delta: Delta

    enum CodingKeys: String, CodingKey {
        case finishReason = "finish_reason"
        case delta
    }
}

struct Delta: Codable {
    let content: String
}
