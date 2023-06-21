//
//  MessageSendingBlock.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 11.06.2023.
//

import UIKit
import RxSwift

protocol MessageSendingViewReactiveType: UIView {
    var messageInputView: Reactive<FlexibleTextView> { get }
    var sendButton: Reactive<UIButton> { get }
    func invalidateMessageInput()
    func shouldStartLoadingAnimation(_ animate: Bool)
}

final class InputBar: UIView {
    
    var maximumTextInputHeight: CGFloat {
        get { messageTextView.maxHeight }
        set { messageTextView.maxHeight = newValue }
    }
    
    private let messageTextView = FlexibleTextView(frame: .zero, textContainer: nil)
    private let sendMessageButton = UIButton(image: .arrow_up,
                                             contentMode: .scaleAspectFit,
                                             tintColor: .hex(0x333333))
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupLayout()
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dismissFocus() {
        messageTextView.resignFirstResponder()
    }
    
    private func setupLayout() {
        addSubviews(messageTextView, sendMessageButton, activityIndicator)
        
        messageTextView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.bottom.equalToSuperview().inset(9)
        }
        
        sendMessageButton.snp.makeConstraints {
            $0.left.equalTo(messageTextView.snp.right).offset(8)
            $0.right.equalToSuperview().inset(10)
            $0.width.height.equalTo(40)
            $0.bottom.equalTo(messageTextView)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.centerX.centerY.equalTo(sendMessageButton)
        }
        
        messageTextView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        messageTextView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    private func setupAppearance() {
        messageTextView.layer.cornerRadius = 20
        messageTextView.backgroundColor = UIColor.hex(0xF1F1F1)
        
        messageTextView.textColor = .black
        messageTextView.font = .systemFont(ofSize: 16)
        messageTextView.placeholder = "Type in your question"
        messageTextView.textContainerInset.left = 10
        messageTextView.textContainerInset.right = 10
        
        sendMessageButton.layer.cornerRadius = 20
        sendMessageButton.backgroundColor = UIColor.hex(0xF1F1F1)
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .black
    }
    
}

extension InputBar: MessageSendingViewReactiveType {
    var messageInputView: Reactive<FlexibleTextView> {
        messageTextView.rx
    }
    
    var sendButton: Reactive<UIButton> {
        sendMessageButton.rx
    }
    
    func invalidateMessageInput() {
        messageTextView.text?.removeAll()
    }
    
    func shouldStartLoadingAnimation(_ animate: Bool) {
        sendMessageButton.isHidden = animate
        animate ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}

