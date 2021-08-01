//
//  PublisherExt.swift
//  MVVMCombine
//
//  Created by Van Le H. on 6/12/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation
import Combine

extension Publisher {
    func element<T: Collection>(at index: T.Index) -> Publishers.CompactMap<Self, T.Element> where Output == T {
        return self
            .compactMap {
                $0[safe: index]
            }
    }

    func transformToAPIResult<T: Decodable>() -> AnyPublisher<APIResult<T>, Never> where Output == T {
        return self
            .map {
                return APIResult.success($0)
            }
            .catch {
                return Just(APIResult.failure($0))
            }
            .eraseToAnyPublisher()
    }

    func handle<T>(onSucess: ((T) -> Void)? = nil, onFailure: ((Error) -> Void)? = nil) -> AnyCancellable
    where Output == APIResult<T>, Self.Failure == Never {
        return self
            .sink {
                switch $0 {
                case .success(let value):
                    onSucess?(value)
                case .failure(let error):
                    onFailure?(error)
                case .none:
                    break
                }
            }
    }
}
