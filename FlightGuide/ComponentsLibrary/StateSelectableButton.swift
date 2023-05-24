//
//  StateSelectableButton.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 24.05.2023.
//

import UIKit
import RxSwift
import RxCocoa

class StateSelectableButton: UIButton {

    enum State {
        case selected
        case deselected
    }
    
    var isInSelectedState: Bool = false {
        didSet {
            currentState = isInSelectedState ? .selected : .deselected
        }
    }
    
    private(set) var currentState: State = .deselected {
        didSet {
            currentState == .selected ? setImage(selectedStateImage, for: .normal) :
            setImage(deselectedStateImage, for: .normal)
        }
    }
    
    private var selectedStateImage: UIImage?
    private var deselectedStateImage: UIImage?
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addTarget(self, action: #selector(changeState), for: .touchUpInside)
    }
    
    func setSelectionStateImage(_ image: UIImage?, for state: State) {
        switch state {
        case .selected: selectedStateImage = image
        case .deselected: deselectedStateImage = image
        }
    }
    
    @objc private func changeState() {
        isInSelectedState.toggle()
    }

}

extension Reactive where Base: StateSelectableButton {
    /// Reactive wrapper for `isInSelectedState` property.
    var isInSelectedState: ControlProperty<Bool> {
        value
    }
    /// Reactive wrapper for `isInSelectedState` property.
    var value: ControlProperty<Bool> {
        return base.rx.controlProperty(
            editingEvents: .touchUpInside,
            getter: { button in
                button.isInSelectedState
            },
            setter: { button, value in
                button.isInSelectedState = value
            }
        )
    }
    
}
