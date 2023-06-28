//
//  EditingRectTextField.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 11.06.2023.
//

import UIKit

final class FlexibleTextView: UITextView {
    
    var maxHeight: CGFloat = 0 {
        didSet { maxHeight = maxHeight > 0 ? maxHeight : 0 }
    }
    
    var placeholder: String? {
        get { placeholderTextView.text }
        set { placeholderTextView.text = newValue }
    }
    
    override var text: String? {
        didSet {
            NotificationCenter.default.post(name: UITextView.textDidChangeNotification, object: self)
        }
    }
    
    override var font: UIFont? {
        didSet {
            placeholderTextView.font = font
            invalidateIntrinsicContentSize()
        }
    }
    
    override var textContainerInset: UIEdgeInsets {
        didSet { placeholderTextView.textContainerInset = textContainerInset }
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        
        if size.height == UIView.noIntrinsicMetric {
            layoutManager.glyphRange(for: textContainer)
            size.height = layoutManager.usedRect(for: textContainer).height + textContainerInset.top + textContainerInset.bottom
        }
        
        if size.height > maxHeight {
            size.height = maxHeight
            isScrollEnabled = true
        } else { isScrollEnabled = false }
        
        return size
    }
    
    private let placeholderTextView: UITextView = {
        let textView = UITextView()
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.textColor = .flg_secondary_gray
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    override init(frame: CGRect = .zero, textContainer: NSTextContainer? = nil) {
        super.init(frame: frame, textContainer: textContainer)
        isScrollEnabled = false
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        placeholderTextView.font = font
        addSubview(placeholderTextView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextView.textDidChangeNotification, object: nil)
        
        NSLayoutConstraint.activate([
            placeholderTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            placeholderTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            placeholderTextView.topAnchor.constraint(equalTo: topAnchor),
            placeholderTextView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func textDidChange(_ note: Notification) {
        invalidateIntrinsicContentSize()
        placeholderTextView.isHidden = !(text?.isEmpty ?? true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
