//
//  UIControlExt.swift
//  CombineExam
//
//  Created by MBA0283F on 4/13/21.
//

import UIKit
import Combine

extension UIButton {
    var tapPublisher: AnyPublisher<Void, Never> {
        ControlPublisher(self, event: .touchUpInside)
            .eraseToAnyPublisher()
    }
}

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        UIControl.ControlPublisher(self, event: .editingChanged)
            .map({ self.text ?? "" })
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}

extension UIControl {
    
    final class ControlSubscription<S: Subscriber, Control: UIControl>: Subscription where S.Input == Void {
        
        private var subscriber: S?
        private var control: Control
        private var event: Control.Event
        
        init(_ subscriber: S, _ control: Control, event: Control.Event) {
            self.subscriber = subscriber
            self.control = control
            self.event = event
            control.addTarget(self, action: #selector(controlAction), for: event)
        }
        
        func request(_ demand: Subscribers.Demand) { }
        
        func cancel() {
            subscriber = nil
        }
        
        @objc private func controlAction(_ sender: Any) {
            _ = subscriber?.receive()
        }
    }
    
    final class ControlPublisher<Control: UIControl>: Publisher {
        typealias Output = Void
        typealias Failure = Never
        
        private let control: Control
        private let event: Control.Event
        
        init(_ control: Control, event: Control.Event) {
            self.control = control
            self.event = event
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            let subscription = ControlSubscription(subscriber, control, event: event)
            subscriber.receive(subscription: subscription)
        }
    }
}
