//
//  API.Store.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/30/21.
//

import Foundation
import Combine

extension API.Store {

    static func requestStores() -> AnyPublisher<CommonResponse<StoreResult>, Error> {
        var urlComponents = URLComponents(string: NetworkService.stores.path)!
        urlComponents.queryItems = [URLQueryItem(name: "key", value: "10ac2eb5ec614737ad26e8d380042bdb")]
        return APIManager.request(url: urlComponents.url!)
            .decode(type: CommonResponse<StoreResult>.self, decoder: JSONDecoder())
            .mapError { error -> APIError in
                switch error {
                case is URLError:
                    return .errorURL
                case is DecodingError:
                    return .errorParsing
                default:
                    return error as? APIError ?? .unknown
                }
            }
            .eraseToAnyPublisher()
    }

    static func requestStoreDetail(id: Int) -> AnyPublisher<StoreResult, Error> {
        var urlComponents = URLComponents(string: NetworkService.storeDetail(id: id).path)!
        urlComponents.queryItems = [URLQueryItem(name: "key", value: "10ac2eb5ec614737ad26e8d380042bdb")]
        return APIManager.request(url: urlComponents.url!)
            .decode(type: StoreResult.self, decoder: JSONDecoder())
            .mapError { error -> APIError in
                switch error {
                case is URLError:
                    return .errorURL
                case is DecodingError:
                    return .errorParsing
                default:
                    return error as? APIError ?? .unknown
                }
            }
            .eraseToAnyPublisher()
    }
}
