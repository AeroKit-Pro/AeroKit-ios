//
//  MessageSendingBlock.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 11.06.2023.
//

import UIKit
import RxSwift

protocol MessageSendingViewReactiveType: UIView {
    var messageField: Reactive<CustomRectTextField> { get }
    var sendButton: Reactive<UIButton> { get }
    func invalidateMessageInput()
}

final class MessageSendingView: UIView {
    
    private let messageTextField = CustomRectTextField(rectInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
    
    private let sendMessageButton = UIButton(image: .arrow_up,
                                             contentMode: .scaleAspectFit,
                                             tintColor: .hex(0x333333))
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupLayout()
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubviews(messageTextField, sendMessageButton)
        
        messageTextField.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.bottom.equalToSuperview().inset(9)
        }
        
        sendMessageButton.snp.makeConstraints {
            $0.left.equalTo(messageTextField.snp.right).offset(8)
            $0.right.equalToSuperview().inset(10)
            $0.top.bottom.equalToSuperview().inset(9)
            $0.width.equalTo(40)
        }
        
        messageTextField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        messageTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    private func setupAppearance() {
        messageTextField.layer.cornerRadius = 10
        messageTextField.backgroundColor = UIColor.hex(0xF1F1F1)
        messageTextField.textColor = .black
        
        sendMessageButton.layer.cornerRadius = 10
        sendMessageButton.backgroundColor = UIColor.hex(0xF1F1F1)
    }
    
}

extension MessageSendingView: MessageSendingViewReactiveType {
    var messageField: RxSwift.Reactive<CustomRectTextField> {
        messageTextField.rx
    }
    
    var sendButton: RxSwift.Reactive<UIButton> {
        sendMessageButton.rx
    }
    
    func invalidateMessageInput() {
        messageTextField.text?.removeAll()
        messageTextField.sendActions(for: .editingChanged)
    }
}
