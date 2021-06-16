//
//  API.Provider.swift
//  CombineDemoError
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 6/11/21.
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

    func request(_ target: Target) -> AnyPublisher<APIOutput, APIError> {
        if stubbed {
            return Just(stubClosure(target))
                .setFailureType(to: APIError.self)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
        let urlString: String = target.baseURLString + target.path
        var urlRequest: URLRequest
        switch target.method {
        case .get, .delete:
            guard var urlComponents: URLComponents = URLComponents(string: urlString) else {
                return Fail<APIOutput, APIError>(error: APIError.errorParsing)
                    .eraseToAnyPublisher()
            }
            if let parameters: [String: Any] = target.parameters {
                urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.0, value: "\($0.1)") }
            }
            guard let url: URL = urlComponents.url else {
                return Fail<APIOutput, APIError>(error: APIError.errorParsing)
                    .eraseToAnyPublisher()
            }
            urlRequest = URLRequest(url: url)
        case .put, .post, .patch:
            guard let url: URL = URL(string: urlString) else {
                return Fail<APIOutput, APIError>(error: APIError.errorParsing)
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
//            .mapError { $0 }
            .mapError({ (err) -> APIError in
                switch err {
                case URLError.badURL:
                    return APIError.errorURL
                case URLError.badServerResponse:
                    return APIError.invalidResponse
                case URLError.cannotParseResponse:
                    return APIError.errorParsing
                default:
                    return APIError.unknown
                }
            })
            .eraseToAnyPublisher()
    }
}

// MARK - APIProvider
extension APIProvider {

    final class func defaultStubClosure(for target: Target) -> APIOutput {
        return (target.sampleData, defaultStubResponse(for: target))
    }

    fileprivate class func defaultStubResponse(for target: Target) -> URLResponse {
        guard let url: URL = URL(string: target.baseURLString + target.path) else {
            fatalError("Invalid URL")
        }
        return HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: target.headers).unwrapped(or: HTTPURLResponse())
    }
}

let stubClosure = { (target: APITarget) -> APIOutput in
    var data: Data = target.sampleData
    let response: URLResponse = APIProvider.defaultStubResponse(for: target)
    return (data, response)
}
