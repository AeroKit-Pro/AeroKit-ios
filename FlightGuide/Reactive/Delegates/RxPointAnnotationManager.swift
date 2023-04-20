//
//  RxPointAnnotationManager.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 31.03.2023.
//

import MapboxMaps
import RxCocoa
import RxSwift

extension PointAnnotationManager: ReactiveCompatible {}

extension PointAnnotationManager: HasDelegate {
    public typealias Delegate = AnnotationInteractionDelegate
}

final class RxAnnotationManagerDelegateProxy: DelegateProxy<PointAnnotationManager, AnnotationInteractionDelegate>, DelegateProxyType, AnnotationInteractionDelegate {
    
    fileprivate let didDetectTappedAnnotation = PublishSubject<PointAnnotation>()
    
    init(parentObject: PointAnnotationManager) {
        super.init(parentObject: parentObject,
                   delegateProxy: RxAnnotationManagerDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { RxAnnotationManagerDelegateProxy(parentObject: $0) }
    }
    
    func annotationManager(_ manager: MapboxMaps.AnnotationManager, didDetectTappedAnnotations annotations: [MapboxMaps.Annotation]) {
        guard let pointAnnotation = annotations.first as? PointAnnotation else { return }
        didDetectTappedAnnotation.onNext(pointAnnotation)
    }
    
}

extension Reactive where Base: PointAnnotationManager {
    fileprivate var delegate: RxAnnotationManagerDelegateProxy {
        RxAnnotationManagerDelegateProxy.proxy(for: base)
    }
    var didDetectTappedAnnotation: ControlEvent<PointAnnotation> {
        ControlEvent(events: delegate.didDetectTappedAnnotation)
    }
}
