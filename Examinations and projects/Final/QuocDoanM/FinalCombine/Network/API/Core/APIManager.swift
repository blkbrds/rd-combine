//
//  APIManager.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/16/21.
//

import Foundation
import Alamofire
import Combine

typealias cancellables = Set<AnyCancellable>
typealias ErasedDataResponsePublisher = AnyPublisher<(data: Data?, response: HTTPURLResponse?), Error>

final class APIManager {

    static let shared: APIManager = APIManager()

    var baseURL: String {
        let rapidHost = Bundle.main.object(forInfoDictionaryKey: "ApiURL") as? String
        return rapidHost.content
    }

    var headers: [String: String] {
        return [
            "x-rapidapi-key": "10ac2eb5ec614737ad26e8d380042bdb",
            "x-rapidapi-host": "https://api.rawg.io/"
        ]
    }
    private init() { }

    func requestWithTarget(_ target: TargetType) -> ErasedDataResponsePublisher {
        let urlString = target.baseURL / target.path
        return request(method: target.method,
                       urlString: urlString,
                       parameters: target.parameters,
                       headers: target.headers)
    }

    private func request(method: HTTPMethod,
                         urlString: String,
                         parameters: Parameters? = nil,
                         headers: [String: String]? = nil) -> ErasedDataResponsePublisher {

        var encoding: ParameterEncoding
        switch method {
        case .get, .delete:
            encoding = URLEncoding()
        default:
            encoding = JSONEncoding()
        }

        var httpHeaders: HTTPHeaders?
        if let headers = headers {
            httpHeaders = HTTPHeaders(headers)
        }

        return AF
            .request(urlString,
                     method: method,
                     parameters: parameters,
                     encoding: encoding,
                     headers: httpHeaders)
            .publishData(queue: DispatchQueue.main)
            .tryMap { value in
                if let error = value.error {
                    throw error
                }
                return (value.data, value.response)
            }
            .eraseToAnyPublisher()
    }

    static func request(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw APIError.invalidResponse
                }
                return data
            }.eraseToAnyPublisher()
    }
}
