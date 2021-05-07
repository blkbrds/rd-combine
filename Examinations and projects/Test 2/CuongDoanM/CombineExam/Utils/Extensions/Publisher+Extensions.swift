//
//  Publisher+Extensions.swift
//  Marvel
//
//  Created by Cuong Doan M. on 4/26/21.
//

import Combine

extension Publisher where Self.Failure == Never {
    
    func erasedFlatMap<P: Publisher>(maxPublishers: Subscribers.Demand = .unlimited, _ transform: @escaping (Self.Output) -> P) -> AnyPublisher<P.Output, P.Failure> {
        flatMap(maxPublishers: maxPublishers, transform)
            .eraseToAnyPublisher()
    }
}
