//
//  AIChatView.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 11.06.2023.
//

import UIKit
import RxSwift

protocol AIChatViewType: UIView {
    var rxInputBar: MessageSendingViewReactiveType { get }
    var tableView: UITableView { get }
    func hidePromptView()
}

final class AIChatView: UIView {
    
    private enum ViewSettings {
        static let messageSendingViewMaximumHeight: CGFloat = 98
        static let messageSendingViewIdleHeight: CGFloat = 58
    }
    
    private let promptView = PromptView(image: .ai_assistant,
                                        message: "Here you can chat with our AI, that will help you solve any question about airplanes and laws",
                                        style: .small)
    private let chatTableView = UITableView()
    private let inputBar = InputBar()
    private let gestureRecognizer = UITapGestureRecognizer()
    private var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupTableView()
        setupLayout()
        setupAppearance()
        subscribeOnNotifications()
        setupGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func keyboardDidChangeFrame(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let endFrameY = endFrame.origin.y
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRaw = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve = UIView.AnimationOptions(rawValue: animationCurveRaw)
        let keyboardHeight = endFrame.size.height - safeAreaInsets.bottom
        
        if endFrameY >= UIScreen.main.bounds.size.height {
            keyboardHeightLayoutConstraint?.constant = 0.0
            tableView.contentOffset.y -= keyboardHeight
        } else {
            let keyboardHeight = endFrame.size.height - safeAreaInsets.bottom
            keyboardHeightLayoutConstraint?.constant = -keyboardHeight
            tableView.contentOffset.y += keyboardHeight
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
    
    @objc private func dismissFocus() {
        inputBar.dismissFocus()
    }
    
    private func setupTableView() {
        chatTableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.identifier)
        chatTableView.dataSource = nil
        
        chatTableView.separatorStyle = .none
        chatTableView.backgroundColor = .clear
    }

    
    private func setupLayout() {
        addSubviews(chatTableView, inputBar, promptView)
        
        promptView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(35)
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview().inset(70)
        }
        
        chatTableView.snp.makeConstraints {
            $0.left.right.top.equalTo(safeAreaLayoutGuide)
        }
        
        inputBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(chatTableView.snp.bottom)
            $0.height.greaterThanOrEqualTo(ViewSettings.messageSendingViewIdleHeight)
        }
        inputBar.maximumTextInputHeight = ViewSettings.messageSendingViewMaximumHeight
        
        keyboardHeightLayoutConstraint = inputBar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        keyboardHeightLayoutConstraint?.isActive = true
    }
    
    private func setupAppearance() {
        backgroundColor = .white
        inputBar.backgroundColor = .white
        
        inputBar.layer.shadowColor = UIColor.black.cgColor
        inputBar.layer.shadowOpacity = 0.05
        inputBar.layer.shadowRadius = 1
        inputBar.layer.shadowOffset = CGSize(width: 0, height: -2)
    }
    
    private func subscribeOnNotifications() {
        NotificationCenter.default.addObserver(self,
               selector: #selector(self.keyboardDidChangeFrame(notification:)),
               name: UIResponder.keyboardWillChangeFrameNotification,
               object: nil)
    }
    
    private func setupGestureRecognizer() {
        gestureRecognizer.addTarget(self, action: #selector(dismissFocus))
        addGestureRecognizer(gestureRecognizer)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
      }
    
}

extension AIChatView: AIChatViewType {
    var rxInputBar: MessageSendingViewReactiveType {
        inputBar
    }
    
    var tableView: UITableView {
        chatTableView
    }
    
    func hidePromptView() {
        promptView.fadeOut(withDuration: AnimationDuration.microFast)
    }
}
