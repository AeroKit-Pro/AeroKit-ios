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
        setupNavigationTitle()
        bindViewModelInputs()
        bindViewModelOutputs()
        aichatView.tableView.delegate = self
        
    }
    
    private func setupNavigationTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "AIChat"
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        
        navigationItem.titleView = titleLabel
    }
    
    private func bindViewModelInputs() {
        aichatView.rxInputBar.messageInputView.text
            .subscribe(onNext: viewModel.inputs.messageInputDidChange(input:))
            .disposed(by: disposeBag)
        
        aichatView.rxInputBar.sendButton.tap
            .subscribe(onNext: viewModel.inputs.didTapSendMessageButton)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModelOutputs() {
        viewModel.outputs.sendMessageButtonIsEnabled
            .bind(to: aichatView.rxInputBar.sendButton.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.outputs.hidePromptView
            .subscribe(onNext: aichatView.hidePromptView)
            .disposed(by: disposeBag)
        
        viewModel.outputs.messageCellViewModels
            .bind(to: aichatView.tableView.rx.items(cellIdentifier: MessageCell.identifier,
                                                     cellType: MessageCell.self)) { _, model, cell in
                cell.viewModel = model
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.invalidateMessageInput
            .subscribe(onNext: aichatView.rxInputBar.invalidateMessageInput)
            .disposed(by: disposeBag)
        
        viewModel.outputs.shouldShowActivityOnAssistantTurn
            .subscribe(onNext: aichatView.rxInputBar.shouldStartLoadingAnimation)
            .disposed(by: disposeBag)
        
        viewModel.outputs.scrollToIndexPath
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                self?.aichatView.tableView.scrollToRow(at: $0, at: .bottom, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
}

extension AIChatViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel.inputs.scrollViewDidScroll(scrollView: scrollView)
    }
}
