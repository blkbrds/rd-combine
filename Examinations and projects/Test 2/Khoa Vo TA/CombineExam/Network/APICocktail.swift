//
//  APICocktail.swift
//  CombineExam
//
//  Created by MBA0242P on 5/9/21.
//

import Foundation
import Combine

final class CocktailService {

    struct CocktailsResponseData: Codable {
        var drinks: [Cocktail]?

        enum CodingKeys: CodingKey {
            case drinks
        }
    }

    func getCocktails(byName name: String) -> AnyPublisher<CocktailsResponseData,Error> {
        guard let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/search.php?s="+"\(name)") else {
            fatalError("Invalid URL")
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map{ $0.data }
            .decode(type: CocktailsResponseData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
