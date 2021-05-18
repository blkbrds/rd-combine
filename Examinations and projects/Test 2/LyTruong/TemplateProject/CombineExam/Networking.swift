//
//  Networking.swift
//  CombineExam
//
//  Created by Ly Truong H on 18/05/2021.
//

import Combine
import Foundation

class Networking {
    func search(searchKey: String) -> AnyPublisher<Drinks, Error> {
        guard let url = URL(string: Api.URLs.apiDrink(keySearch: searchKey)) else {
            fatalError("Invalid URL")
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Drinks.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func fetchData() -> AnyPublisher<Drinks, Error> {
        guard let url = URL(string: Api.URLs.apiDrink(keySearch: "a")) else {
            fatalError("Invalid URL")
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Drinks.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}


struct Api {
    struct URLs {
        static func apiDrink(keySearch: String) -> String {
            return "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\(keySearch)"
        }
    }
}
