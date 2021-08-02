//
//  UIControlPublisher.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/13/21.
//

import UIKit
import Combine

// MARK: - Publisher
struct EventPublisher<Control: UIControl>: Publisher {
    
    typealias Output = Void
    
    typealias Failure = Never
    
    let control: Control
    let event: UIControl.Event

    init(control: Control, event: UIControl.Event) {
        self.control = control
        self.event = event
    }
    
    func receive<S: Subscriber>(subscriber: S) where S.Failure == Failure, S.Input == Output {
        let subscription = ControlSubscription(subscriber: subscriber, control: control, event: event)
        subscriber.receive(subscription: subscription)
    }
}

// MARK: - Subscription
final class ControlSubscription<S: Subscriber, Control: UIControl>: Subscription where S.Input == Void {

    var subscriber: S?
    let control: Control

    init(subscriber: S, control: Control, event: UIControl.Event) {
            self.subscriber = subscriber
            self.control = control
            control.addTarget(self, action: #selector(eventHandler), for: event)
        }

    func request(_ demand: Subscribers.Demand) { }
    
    func cancel() {
        subscriber = nil
    }

    @objc func eventHandler() {
        _ = subscriber?.receive()
    }
}
