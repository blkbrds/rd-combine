//
//  APIProvider.swift
//  CombineExam
//
//  Created by Cuong Doan M. on 4/27/21.
//

import Foundation
import Combine

final class APIProvider<Target> where Target: APITargetType {
    
    typealias StubClosure = (Target) -> APIOutput
    
    private let stubbed: Bool
    private let stubClosure: StubClosure
    
    init(stubbed: Bool = false, stubClosure: @escaping StubClosure = APIProvider.defaultStubClosure) {
        self.stubbed = stubbed
        self.stubClosure = stubClosure
    }
    
    func request(_ target: Target) -> AnyPublisher<APIOutput, Error> {
        if stubbed {
            return Just(stubClosure(target))
                .setFailureType(to: Error.self)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
        let urlString: String = target.baseURLString + target.path
        var urlRequest: URLRequest
        switch target.method {
        case .get, .delete:
            guard var urlComponents: URLComponents = URLComponents(string: urlString) else {
                return Fail<APIOutput, Error>(error: NSError.service)
                    .eraseToAnyPublisher()
            }
            if let parameters: [String: Any] = target.parameters {
                urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.0, value: "\($0.1)") }
            }
            guard let url: URL = urlComponents.url else {
                return Fail<APIOutput, Error>(error: NSError.service)
                    .eraseToAnyPublisher()
            }
            urlRequest = URLRequest(url: url)
        case .put, .post, .patch:
            guard let url: URL = URL(string: urlString) else {
                return Fail<APIOutput, Error>(error: NSError.service)
                    .eraseToAnyPublisher()
            }
            urlRequest = URLRequest(url: url)
            if let parameters: [String: Any] = target.parameters {
                let httpBody: Data? = try? JSONSerialization.data(withJSONObject: parameters, options: [])
                urlRequest.httpBody = httpBody
            }
        }
        if let headers: [String: String] = target.headers {
            headers.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
        }
        urlRequest.httpMethod = target.method.rawValue
        return URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .receive(on: DispatchQueue.main)
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}
