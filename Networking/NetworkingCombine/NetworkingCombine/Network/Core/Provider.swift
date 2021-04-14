//
//  Provider.swift
//  NetworkingCombine
//
//  Created by MBP0051 on 4/13/21.
//

import Foundation
import Combine

protocol ProviderType: AnyObject {
    
    associatedtype Target: TargetType
}

typealias RequestPublisher = AnyPublisher<URLSession.DataTaskPublisher.Output, Error>

final class Provider<Target: TargetType>: ProviderType {
    
    func request(target: Target) -> RequestPublisher {
        if let rq = target.getRequest() {
            let publisher: RequestPublisher = URLSession.shared.dataTaskPublisher(for: rq)
                .mapError({ $0 })
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
            return publisher
        } else {
            let publisher: RequestPublisher = Fail<URLSession.DataTaskPublisher.Output, Error>(error: APIError.invalidServerResponse)
                .eraseToAnyPublisher()
            return publisher
        }
    }
}

extension RequestPublisher {
    
    func catchAPIError() -> Self {
        let publisher = tryMap { output -> URLSession.DataTaskPublisher.Output in
            guard let response = output.response as? HTTPURLResponse else {
                return output
            }
            
            switch response.statusCode {
            case 200...299:
                return output
            case 400...600:
                throw APIError.invalidServerResponse
            default:
                throw APIError.invalidServerResponse
            }
        }.eraseToAnyPublisher()
        return publisher   
    }
    
    func decode<D: Decodable>(_ type: D.Type, using decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<D, Error> {   
        let publisher = map { $0.data }
            .decode(type: D.self, decoder: decoder)
            .print()
            .eraseToAnyPublisher()
        return publisher
    }
}
