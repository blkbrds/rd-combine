//
//  Networking.swift
//  BaiTapNetworking
//
//  Created by Trung Le D. on 5/7/21.
//

import Foundation
import Combine

class Networking {
    func fetchData() -> AnyPublisher<Drink, Error> {
        guard let url = URL(string: Api.URLs.defaultData()) else {
            fatalError("Invalid URL")
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: DrinkRespond.self, decoder: JSONDecoder())
            .map {
                $0.main
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()

    }

    func search(keySearch: String) -> AnyPublisher<Drink, Error> {
        guard let url = URL(string: Api.URLs.drink(keySearch: keySearch)) else {
            fatalError("Invalid URL")
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data}
            .decode(type: DrinkRespond.self, decoder: JSONDecoder())
            .map {
                $0.main
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
