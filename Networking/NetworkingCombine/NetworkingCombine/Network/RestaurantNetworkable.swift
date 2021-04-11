//
//  RestaurantNetworkable.swift
//  List-NavigationDemo
//
//  Created by MBA0321 on 3/5/21.
//

import Foundation
import Combine

typealias Parameters = [String: Any]
typealias RequestPublisher = AnyPublisher<(data: Data, response: URLResponse), Error>

protocol RestaurantNetworkable {

    func getTrendings(page: Int) -> AnyPublisher<RestaurantNetworkManager.TrendingResponseData, Error>
    func getPopulars(page: Int) -> AnyPublisher<RestaurantNetworkManager.PopularResponseData, Error>
}

final class RestaurantNetworkManager: RestaurantNetworkable {

    var provider: Provider<RestauranService> = Provider<RestauranService>()

    func getTrendings(page: Int) -> AnyPublisher<RestaurantNetworkManager.TrendingResponseData, Error> {
        return provider.requestWithTarget(target: .trendings(page: page))
            .response()
    }
    func getPopulars(page: Int) -> AnyPublisher<RestaurantNetworkManager.PopularResponseData, Error> {
        return provider.requestWithTarget(target: .populars(page: page))
            .response()
    }
}

extension RestaurantNetworkManager {

    struct PopularResponseData: Codable {
        var data: [Restaurant]
        
        enum CodingKeys: String, CodingKey {
            case data = "ads"
        }
    }
    
    struct TrendingResponseData: Codable {
        var data: [Restaurant]
        
        enum CodingKeys: String, CodingKey {
            case data = "ads"
        }
    }
}


protocol ProviderType: AnyObject {

    associatedtype Target: TargetType
}

final class Provider<Target: TargetType>: ProviderType {
    
    func requestWithTarget(target: Target) -> RequestPublisher {
        let urlString = target.baseURL.absoluteString + target.path
        return request(method: target.method,
                       urlString: urlString,
                       parameters: target.parameters,
                       headers: target.headers)
    }

    func request(method: HTTPMethod, urlString: String, parameters: Parameters? = nil, headers: [String: String]? = nil) -> RequestPublisher {
        guard let url = URL(string: urlString) else {
            return Fail<URLSession.DataTaskPublisher.Output, Error>(error: APIError.cannotToCreateRequest)
                .eraseToAnyPublisher()
        }
        var urlRequest: URLRequest = URLRequest(url: url)
        switch method {
        case .get, .delete:
            guard var urlComponents = URLComponents(string: urlString) else {
                return Fail<URLSession.DataTaskPublisher.Output, Error>(error: APIError.cannotToCreateRequest)
                    .eraseToAnyPublisher()
            }
            if let parameters = parameters {
                urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.0, value: "\($0.1)") }
            }
            guard let url = urlComponents.url else {
                return Fail<URLSession.DataTaskPublisher.Output, Error>(error: APIError.cannotToCreateRequest)
                    .eraseToAnyPublisher()
            }
            
            urlRequest = URLRequest(url: url)
            if let headers = headers {
                for (key, value) in headers {
                    urlRequest.setValue(value, forHTTPHeaderField: key)
                }
            }
        case .put, .post, .patch:
            if let parameters = parameters {
                guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                    return Fail<URLSession.DataTaskPublisher.Output, Error>(error: APIError.cannotToCreateRequest)
                        .eraseToAnyPublisher()
                }
                urlRequest.httpBody = httpBody
            }
        default:
            break
        }

        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .mapError({ $0 })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}


extension RequestPublisher {
    
    func response<T>() -> AnyPublisher<T, Error> where T: Codable {
        let publisher = tryMap { result -> Data in
            if let response = result.response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                return result.data
            }
            throw APIError.cannotToCreateRequest
        }
        .decode(type: T.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
        return publisher
    }
}
