//
//  PublisherExt.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/31/21.
//

import Foundation
import Combine

extension Publisher {

    func element<T: Collection>(at index: T.Index) -> Publishers.CompactMap<Self, T.Element> where Output == T {
        return self
            .compactMap {
                $0[index]
            }
    }

    func transformToAPIResult<T>() -> AnyPublisher<APIResult<T>, Never> where Output == T {
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
