//
//  ApiManager.swift
//  FinalProject_Combine
//
//  Created by An Nguyen Q. VN.Danang on 7/7/21.
//

import Foundation
import Combine

struct ApiManager {
    enum EndPoint {
        static let baseURL = URL(string: "https://rss.itunes.apple.com/api/v1/us/apple-music")!
        
        case coming_soon(Int)
        
        var url: URL {
            switch self {
            case .coming_soon(let limit):
                return EndPoint.baseURL.appendingPathComponent("/coming-soon/all/\(limit)/aexplicit.json")
            }
        }
        
    }
    
//    let url = EndPoint.coming_soon(10).url
    
    //MARK: Properties
    private let decoder = JSONDecoder()
    
    private let apiQueue = DispatchQueue(label: "API", qos: .default, attributes: .concurrent)
    
    func getMusicList(limit: Int) -> AnyPublisher<FeedResults, APIError> {
        return URLSession.shared
            .dataTaskPublisher(for: EndPoint.coming_soon(limit).url)
            .subscribe(on: apiQueue)
            .tryMap { output in
                guard let _ = output.response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                return output.data
            }
            .decode(type: FeedResults.self, decoder: decoder)
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
