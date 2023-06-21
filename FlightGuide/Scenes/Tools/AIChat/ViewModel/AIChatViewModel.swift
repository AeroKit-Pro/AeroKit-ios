//
//  AIChatViewModel.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 11.06.2023.
//

import Foundation
import RxSwift
import RxRelay
import UIKit

protocol AIChatViewModelInputs {
    func messageInputDidChange(input: String?)
    func didTapSendMessageButton()
    func scrollViewDidScroll(scrollView: UIScrollView)
}

protocol AIChatViewModelOutputs {
    typealias Empty = ()
    typealias MessageCellViewModels = [MessageCellViewModel]
    
    var sendMessageButtonIsEnabled: Observable<Bool>! { get }
    var messageCellViewModels: Observable<MessageCellViewModels>! { get }
    var invalidateMessageInput: Observable<Empty>! { get }
    var scrollToIndexPath: Observable<IndexPath>! { get }
    var shouldShowActivityOnAssistantTurn: Observable<Bool>! { get }
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
    var shouldShowActivityOnAssistantTurn: Observable<Bool>!
    
    private let messageInput = PublishRelay<String?>()
    private let messageButtonTapped = PublishRelay<Empty>()
    private let scrollViewScrolled = PublishRelay<UIScrollView>()
    
    private let openAIChat: OpenAIChatType = OpenAIChat(parameters: .default)
    
    var inputs: AIChatViewModelInputs { self }
    var outputs: AIChatViewModelOutputs { self }
    
    init() {
        let unwrappedMessageInput = messageInput
            .compactMap { $0 }
            .share()
        
        let hasMessageInput = unwrappedMessageInput
            .map { $0.trimmingCharacters(in: .whitespaces).notEmpty }
            .startWith(false)
            .distinctUntilChanged()
        
        let isInUserTurn = Observable
            .merge(messageButtonTapped.map { _ in false },
                   openAIChat.streamDidEnd.map { _ in true })
            .startWith(true)
            .distinctUntilChanged()
        
        self.shouldShowActivityOnAssistantTurn = isInUserTurn.map { !$0 }.asObservable()
        
        self.sendMessageButtonIsEnabled = Observable
            .combineLatest(hasMessageInput, isInUserTurn)
            .map { $0.0 && $0.1 }
            .distinctUntilChanged()
        
        messageButtonTapped.withLatestFrom(unwrappedMessageInput)
            .do(onNext: { self.openAIChat.postUserMessage($0) })
            .subscribe()
                
        let messages = openAIChat.messages
            .map { $0.filter { $0.role != .system } }
            .share()
        
        self.messageCellViewModels = messages
            .map { $0.map { MessageCellViewModel(with: $0) } }
        
        let latestMessageIndexPath = messages
            .compactMap { $0.lastIndex(where: { _ in true }) }
            .map { IndexPath(row: $0, section: 0) }
        
        let didScrollToBottom = scrollViewScrolled
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .map { scrollView in
                let offsetY = scrollView.contentOffset.y
                let contentHeight = scrollView.contentSize.height
                let tableViewHeight = scrollView.frame.height
                
                return offsetY >= contentHeight - tableViewHeight - 80
            }
            .observe(on: MainScheduler.asyncInstance)
            .startWith(true)
            .distinctUntilChanged()
        
        let shouldStickToBottom = messages.map { _ in true }
            .withLatestFrom(didScrollToBottom) { ($0, $1) }
            .filter { $0.0 && $0.1 }
        
        self.scrollToIndexPath = shouldStickToBottom.withLatestFrom(latestMessageIndexPath)
        
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
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollViewScrolled.accept(scrollView)
    }
}
