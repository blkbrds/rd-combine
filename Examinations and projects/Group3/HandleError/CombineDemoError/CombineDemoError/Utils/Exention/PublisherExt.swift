//
//  PublisherExt.swift
//  CombineDemoError
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 6/14/21.
//

import Combine

extension Publisher where Self.Failure == Never {
    /// flatMap new `Publisher` when error `Never`
    func erasedFlatMap<P: Publisher>(maxPublishers: Subscribers.Demand = .unlimited, _ transform: @escaping (Self.Output) -> P) -> AnyPublisher<P.Output, P.Failure> {
        flatMap(maxPublishers: maxPublishers, transform)
            .eraseToAnyPublisher()
    }
}
