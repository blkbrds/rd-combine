//
//  URLSessionRequest.swift
//  CombineExam
//
//  Created by Quoc Doan M. on 5/7/21.
//

import Foundation
import Combine

final class URLSessionRequest {
    static let shared: URLSessionRequest = URLSessionRequest()

    func getConktailSearchResult(from url: URL) -> AnyPublisher<CocktailsResponse, Never> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: CocktailsResponse.self, decoder: JSONDecoder())
            .replaceError(with: CocktailsResponse.init(drinks: []))
            .eraseToAnyPublisher()
    }
}
