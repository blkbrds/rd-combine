//
//  API.Search.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 8/2/21.
//

import Foundation
import Combine

extension API.Search {

    static func requestGameDetail(id: Int) -> AnyPublisher<GameDetailResponse, Error> {
        var urlComponents = URLComponents(string: NetworkService.gamePerStoreDetail(id: id).path)!
        urlComponents.queryItems = [URLQueryItem(name: "key", value: "10ac2eb5ec614737ad26e8d380042bdb")]
        return APIManager.request(url: urlComponents.url!)
            .decode(type: GameDetailResponse.self, decoder: JSONDecoder())
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

    static func requestSearchGame(isLoadMore: Bool = false, type: NetworkService, keyword: String) -> AnyPublisher<CommonResponse<GameDetailResponse>, APIError> {
        var urlComponents = URLComponents(string: type.path)!
        urlComponents.queryItems = [URLQueryItem(name: "key", value: "10ac2eb5ec614737ad26e8d380042bdb"), URLQueryItem(name: "search", value: keyword)]
        return APIManager.request(url: urlComponents.url!)
            .decode(type: CommonResponse<GameDetailResponse>.self, decoder: JSONDecoder())
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

    static func requestLoadMoreSearch(url: URL) -> AnyPublisher<CommonResponse<GameDetailResponse>, APIError> {
        return APIManager.request(url: url)
            .decode(type: CommonResponse<GameDetailResponse>.self, decoder: JSONDecoder())
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
