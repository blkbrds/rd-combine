//
//  Networking.swift
//  LyTruongH
//
//  Created by Ly Truong H. VN.Danang on 27/07/2021.
//

import UIKit
import Combine

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

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
