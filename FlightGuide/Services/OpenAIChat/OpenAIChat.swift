//
//  OpenAIChatWrapper.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 17.06.2023.
//

import Foundation
import Alamofire
import RxSwift
import RxRelay

protocol OpenAIChatType {
    func postUserMessage(_ message: String)
    var messages: Observable<[Message]> { get }
    var streamDidEnd: Observable<()> { get }
}

final class OpenAIChat {
        
    private let apiClient = APIClient()
    private var parameters: OpenAIChatStreamedParameters
    private let messageRelay = PublishRelay<[Message]>()
    private let onStreamEnd = PublishRelay<()>()
    
    init(parameters: OpenAIChatStreamedParameters) {
        self.parameters = parameters
    }
    
    private func handleStream(_ stream: DataStreamRequest.Stream<String, Never>) {
        switch stream.event {
        case .stream(let response):
            switch response {
            case .success(let string):
                self.parseStreamString(string: string)
            }
        case .complete(_:):
            onStreamEnd.accept(())
        }
    }
    
    private func parseStreamString(string: String) {
        let splittedResponse = string.components(separatedBy: "data:")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        let decoder = JSONDecoder()
        let chunks: [ChatCompletionChunk] = splittedResponse
            .compactMap { jsonString in
                guard let data = jsonString.data(using: .utf8),
                      let chunk = try? decoder.decode(ChatCompletionChunk.self, from: data) else { return nil }
                return chunk
            }
        distributeMessageDeltas(of: chunks)
    }
    
    private func distributeMessageDeltas(of chunks: [ChatCompletionChunk]) {
        chunks.forEach { chunk in
            let content = chunk.choices.map { $0.delta.content }.joined()
            guard let latestAssistantResponseIndex = parameters.messages.lastIndex(where: { $0.id == chunk.id }) else {
                let newAssistantResponse = Message(id: chunk.id, role: .assistant, content: content)
                parameters.messages.append(newAssistantResponse)
                return
            }
            parameters.messages[latestAssistantResponseIndex].content += content
        }
        messageRelay.accept(parameters.messages)
    }
    
}

extension OpenAIChat: OpenAIChatType {
    func postUserMessage(_ message: String) {
        let userMessage = Message(role: .user, content: message)
        parameters.messages.append(userMessage)
        messageRelay.accept(parameters.messages)
        apiClient.createStreamChatCompletion(parameters: parameters.asData())
            .responseStreamString { [weak self] stream in
                guard let self = self else { return }
                self.handleStream(stream)
            }
    }

    var messages: Observable<[Message]> {
        messageRelay.asObservable()
    }
    
    var streamDidEnd: Observable<()> {
        onStreamEnd.asObservable()
    }
}
