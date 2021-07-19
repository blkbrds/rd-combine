//
//  API.Networking.swift
//  FinalCombine
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 7/20/21.
//

import Foundation
import Combine

protocol APINetworkingType {

    associatedtype T: APITargetType
    var provider: APIProvider<T> { get }
    func request(_ target: T) -> AnyPublisher<APIOutput, Error>
}

extension APINetworkingType {

    func request(_ target: T) -> AnyPublisher<APIOutput, Error> {
        provider.request(target)
    }
}

let apiProvider: APINetworking = APINetworking.shared

final class APINetworking: APINetworkingType {

    static let shared: APINetworking = APINetworking()

    let provider: APIProvider<APITarget>

    init(stubbed: Bool = false, closure: APIProvider<APITarget>.StubClosure? = nil) {
        if stubbed {
            let closure: APIProvider<APITarget>.StubClosure = closure.unwrapped(or: stubClosure)
            provider = APIProvider(stubbed: true, stubClosure: closure)
        } else {
            provider = APIProvider()
        }
    }
}
