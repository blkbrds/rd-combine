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

class Provider<Target: TargetType>: ProviderType {
    
    func request(target: Target) -> RequestPublisher {
        if let rq = target.getRequest() {
            let publisher: RequestPublisher = URLSession.shared.dataTaskPublisher(for: rq)
                .mapError({ error -> APIError in
                    .network(from: error)
                })
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
            return publisher
        } else {
            let publisher: RequestPublisher = Fail<URLSession.DataTaskPublisher.Output, Error>(error: APIError.unknown)
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
                throw APIError.badRequest
            default:
                throw APIError.unknown
            }
        }
        .eraseToAnyPublisher()
        return publisher
    }
    
    func decode<D: Decodable>(_ type: D.Type, using decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<D, Error> {   
        let publisher = map { return $0.data }
            .decode(type: D.self, decoder: decoder)
            .print()
            .eraseToAnyPublisher()
        return publisher
    }
}

class MockProviderClient<Target: TargetType>: Provider<Target> {

    override func request(target: Target) -> RequestPublisher {
        Future<URLSession.DataTaskPublisher.Output, Error> { promise in
//            let output : URLSession.DataTaskPublisher.Output = (target.sampleData, URLResponse())
//            promise(.success(output))
            
            promise(.failure(APIError.unknown))
        }.eraseToAnyPublisher()
    }
}
