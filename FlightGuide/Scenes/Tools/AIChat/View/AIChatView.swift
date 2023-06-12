//
//  AIChatView.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 11.06.2023.
//

import UIKit
import RxSwift

protocol AIChatViewType: UIView {
    var rxMessageSendingBlock: MessageSendingViewReactiveType { get }
    var tableView: UITableView { get }
}

final class AIChatView: UIView {
    
    private let chatTableView = UITableView()
    private let messageSendingBlock: MessageSendingViewReactiveType = MessageSendingView()
    private var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupTableView()
        setupLayout()
        setupAppearance()
        subscribeOnNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let endFrameY = endFrame.origin.y
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRaw = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        if endFrameY >= UIScreen.main.bounds.size.height {
            keyboardHeightLayoutConstraint?.constant = 0.0
        } else {
            let keyboardHeight = endFrame.size.height - safeAreaInsets.bottom
            keyboardHeightLayoutConstraint?.constant = -keyboardHeight
        }
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: animationCurve,
            animations: {
                self.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    private func setupTableView() {
        chatTableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.identifier)
        chatTableView.dataSource = nil
        
        chatTableView.separatorStyle = .none
        chatTableView.backgroundColor = .clear
    }

    
    private func setupLayout() {
        addSubviews(chatTableView, messageSendingBlock)
        
        chatTableView.snp.makeConstraints {
            $0.left.right.top.equalTo(safeAreaLayoutGuide)
        }
        
        messageSendingBlock.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(chatTableView.snp.bottom)
            $0.height.equalTo(58)
        }
        
        keyboardHeightLayoutConstraint = messageSendingBlock.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        keyboardHeightLayoutConstraint?.isActive = true
    }
    
    private func setupAppearance() {
        backgroundColor = .white
    }
    
    private func subscribeOnNotifications() {
        NotificationCenter.default.addObserver(self,
               selector: #selector(self.keyboardNotification(notification:)),
               name: UIResponder.keyboardWillChangeFrameNotification,
               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
      }
    
}

extension AIChatView: AIChatViewType {
    var rxMessageSendingBlock: MessageSendingViewReactiveType {
        messageSendingBlock
    }
    
    var tableView: UITableView {
        chatTableView
    }
}
