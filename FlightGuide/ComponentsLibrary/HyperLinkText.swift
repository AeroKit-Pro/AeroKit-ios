//
//  HyperLinkTextView.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 20.07.2023.
//

import UIKit
import RxCocoa

final class HyperLinkText: UITextView {
    
    let tappedOnLinkPart = PublishRelay<()>()
    
    init(text: String, tapPart: String, link: String, font: UIFont, textColor: UIColor) {
        super.init(frame: .zero, textContainer: nil)
        setup(text: text, tapPart: tapPart, link: link, font: font, textColor: textColor)
        delegate = self
        isScrollEnabled = false
        isEditable = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(text: String, tapPart: String, link: String, font: UIFont, textColor: UIColor) {
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font : font, .foregroundColor : textColor])
        let range = attributedString.mutableString.range(of: tapPart)
        attributedString.addAttribute(.link, value: link, range: range)
        linkTextAttributes = [.foregroundColor : textColor, .underlineStyle : NSUnderlineStyle.single.rawValue]
        backgroundColor = .clear
        
        attributedText = attributedString
    }
    
}

extension HyperLinkText: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        tappedOnLinkPart.accept(())
        
        return false
    }
}
