//
//  AIChatViewController.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 11.06.2023.
//

import UIKit
import RxSwift

final class AIChatViewController: UIViewController {
    
    var viewModel: AIChatViewModelType!
    private let aichatView: AIChatViewType = AIChatView()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = aichatView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModelInputs()
        bindViewModelOutputs()
        navigationItem.title = "Chat"
    }
    
    private func bindViewModelInputs() {
        aichatView.rxMessageSendingBlock.messageInputView.text
            .subscribe(onNext: viewModel.inputs.messageInputDidChange(input:))
            .disposed(by: disposeBag)
        
        aichatView.rxMessageSendingBlock.sendButton.tap
            .subscribe(onNext: viewModel.inputs.didTapSendMessageButton)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModelOutputs() {
        viewModel.outputs.sendMessageButtonIsEnabled
            .bind(to: aichatView.rxMessageSendingBlock.sendButton.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.outputs.messageCellViewModels
            .bind(to: aichatView.tableView.rx.items(cellIdentifier: MessageCell.identifier,
                                                     cellType: MessageCell.self)) { _, model, cell in
                cell.viewModel = model
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.invalidateMessageInput
            .subscribe(onNext: aichatView.rxMessageSendingBlock.invalidateMessageInput)
            .disposed(by: disposeBag)
        
        viewModel.outputs.scrollToIndexPath
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                self?.aichatView.tableView.scrollToRow(at: $0, at: .bottom, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
}
