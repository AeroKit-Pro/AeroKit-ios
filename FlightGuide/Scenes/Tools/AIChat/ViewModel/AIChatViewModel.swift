//
//  AIChatViewModel.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 11.06.2023.
//

import Foundation
import RxSwift
import RxRelay

protocol AIChatViewModelInputs {
    func messageInputDidChange(input: String?)
    func didTapSendMessageButton()
}

protocol AIChatViewModelOutputs {
    typealias Empty = ()
    typealias MessageCellViewModels = [MessageCellViewModel]
    
    var sendMessageButtonIsEnabled: Observable<Bool>! { get }
    var messageCellViewModels: Observable<MessageCellViewModels>! { get }
    var invalidateMessageInput: Observable<Empty>! { get }
    var scrollToIndexPath: Observable<IndexPath>! { get }
}

protocol AIChatViewModelType {
    var inputs: AIChatViewModelInputs { get }
    var outputs: AIChatViewModelOutputs { get }
}

final class AIChatViewModel: AIChatViewModelType, AIChatViewModelOutputs {
    
    var sendMessageButtonIsEnabled: Observable<Bool>!
    var messageCellViewModels: Observable<MessageCellViewModels>!
    var invalidateMessageInput: Observable<Empty>!
    var scrollToIndexPath: Observable<IndexPath>!
    
    private let messageInput = PublishRelay<String?>()
    private let messageButtonTapped = PublishRelay<Empty>()
    
    var inputs: AIChatViewModelInputs { self }
    var outputs: AIChatViewModelOutputs { self }
    
    init() {
        let unwrappedMessageInput = messageInput.compactMap { $0 }
        
        self.sendMessageButtonIsEnabled = unwrappedMessageInput.map { !$0.trimmingCharacters(in: .whitespaces).isEmpty } // change to not empty
            .startWith(false)
            .distinctUntilChanged()
        
        let userMessagesViewModels = messageButtonTapped.withLatestFrom(unwrappedMessageInput) { $1 }
            .map { MessageCellViewModel(message: $0, time: Date().getLocalisedTime()) }
            .map { [$0] }
        
        let accumulatedCellViewModels = userMessagesViewModels
            .scan([]) { viewModels, newViewModel in
                return viewModels + newViewModel
            }
        
        self.messageCellViewModels = accumulatedCellViewModels
        
        let latestMessageIndexPath = accumulatedCellViewModels
            .compactMap { $0.lastIndex(where: { _ in true }) }
            .map { IndexPath(row: $0, section: 0) }
        
        self.scrollToIndexPath = messageButtonTapped.withLatestFrom(latestMessageIndexPath)
                
        self.invalidateMessageInput = messageButtonTapped.asObservable()
    }
    
}

// MARK: - AIChatViewModelInputs
extension AIChatViewModel: AIChatViewModelInputs {
    func messageInputDidChange(input: String?) {
        messageInput.accept(input)
    }
    func didTapSendMessageButton() {
        messageButtonTapped.accept(Empty())
    }
}
