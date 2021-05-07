//
//  CocktailService.swift
//  BaiTap02
//
//  Created by Trin Nguyen X on 5/7/21.
//  Copyright © 2021 Trin Nguyen Xuan. All rights reserved.
//

import Foundation
import Combine

final class CocktailService {

    func getCocktailByName(searchText: String) -> AnyPublisher<CocktailsResponseData,Error> {
        guard let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/search.php?s="+"\(searchText)") else {
            fatalError("Invalid URL")
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map{ $0.data }
            .decode(type: CocktailsResponseData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

extension CocktailService {

    struct CocktailsResponseData: Codable {
        var data: [Cocktail]?

        enum CodingKeys: String, CodingKey {
            case data = "drinks"
        }
    }
}
