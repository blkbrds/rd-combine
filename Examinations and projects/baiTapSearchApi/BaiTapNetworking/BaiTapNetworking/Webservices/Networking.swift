//
//  Networking.swift
//  BaiTapNetworking
//
//  Created by Trung Le D. on 5/7/21.
//

import Foundation
import Combine

class Networking {

    func search(searchKey: String) -> AnyPublisher<DrinkRespond, Error>  {
        guard let url = URL(string: Api.URLs.drink(keySearch: searchKey)) else {
            fatalError("Invalid URL")
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data}
            .decode(type: DrinkRespond.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func fetchData() -> AnyPublisher<DrinkRespond, Error>  {
        guard let url = URL(string: Api.URLs.defaultData()) else {
            fatalError("Invalid URL")
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data}
            .decode(type: DrinkRespond.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
