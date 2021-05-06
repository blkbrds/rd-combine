//
//  CocktailService.swift
//  CombineExam
//
//  Created by Toan Nguyen D. [4] on 5/6/21.
//

import Foundation
import Combine

enum ServiceError: Error {
    case url(URLError)
    case urlRequest
    case decode
}

protocol CocktailServiceProtocol {
    func get(searchTerm: String?) -> AnyPublisher<[Cocktail], Error>
}

final class CocktailService: CocktailServiceProtocol {

    func get(searchTerm: String?) -> AnyPublisher<[Cocktail], Error> {
        var dataTask: URLSessionDataTask?

        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }

        return Future<[Cocktail], Error> { [weak self] promise in
            guard let urlRequest = self?.getUrlRequest(searchTerm: searchTerm) else {
                promise(.failure(ServiceError.urlRequest))
                return
            }

            dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                guard let data = data else {
                    if let error = error {
                        promise(.failure(error))
                    }
                    return
                }
                do {
                    let players = try JSONDecoder().decode(Drinks.self, from: data)
                    promise(.success(players.drinks))
                } catch {
                    promise(.failure(ServiceError.decode))
                }
            }
        }
        .handleEvents(receiveSubscription: onSubscription, receiveCancel: onCancel)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    //https://www.thecocktaildb.com/api/json/v1/1/search.php?s=m
    private func getUrlRequest(searchTerm: String?) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "thecocktaildb.com"
        components.path = "/api/json/v1/1/search.php"
        if let searchTerm = searchTerm, !searchTerm.isEmpty {
            components.query = "s=\(searchTerm)"
        } else {
            components.query = "s="
        }

        guard let url = components.url else { return nil }

        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 30.0
        urlRequest.httpMethod = "GET"
        return urlRequest
    }
}
