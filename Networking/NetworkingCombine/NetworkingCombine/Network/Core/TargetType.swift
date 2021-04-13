//
//  TargetType.swift
//  List-NavigationDemo
//
//  Created by MBA0321 on 3/5/21.
//

import Foundation

protocol TargetType {

    /// The target's base `URL`.
    var baseURL: URL { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var method: HTTPMethod { get }

    /// Provides stub data for use in testing.
    var sampleData: Data { get }

    /// The type of HTTP task to be performed.
    var parameters: Parameters { get }

    /// The type of validation to perform on the request. Default is `.none`.
//    var validationType: ValidationType { get }

    /// The headers to be used in the request.
    var headers: [String: String]? { get }
}

extension TargetType {
    
    func getRequest() -> URLRequest? {
        let urlString = baseURL.absoluteString + path
        guard let url = URL(string: urlString) else { return nil }
        var urlRequest: URLRequest = URLRequest(url: url)
        switch method {
        case .get, .delete:
            guard var urlComponents = URLComponents(string: urlString) else {
                return nil
            }
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.0, value: "\($0.1)") }
            
            guard let url = urlComponents.url else {
                return nil
            }
            
            urlRequest = URLRequest(url: url)
            if let headers = headers {
                for (key, value) in headers {
                    urlRequest.setValue(value, forHTTPHeaderField: key)
                }
            }
        case .put, .post, .patch:
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                return nil
            }
            urlRequest.httpBody = httpBody
        default:
            break
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}
