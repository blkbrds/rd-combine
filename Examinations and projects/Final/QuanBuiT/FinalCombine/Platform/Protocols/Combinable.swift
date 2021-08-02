//
//  Combinable.swift
//  Platform
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import Combine

public protocol Combinable {}

extension Networking where Self: Combinable {
    func sendRequestPublisher(_ request: URLRequest) -> AnyPublisher<Result<Data, NetworkingError>, Never> {
        Future { promise in
            self.send(request) { result in
                promise(.success(result))
            }
        }.eraseToAnyPublisher()
    }
}
