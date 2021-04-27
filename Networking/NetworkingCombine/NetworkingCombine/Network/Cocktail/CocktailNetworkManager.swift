//
//  CocktailNetworkManager.swift
//  NetworkingCombine
//
//  Created by MBA0253P on 4/14/21.
//

import Combine

struct CocktailNetworkManager: CocktailNetworkable {

    var provider: Provider<CocktailService> = Provider<CocktailService>()

    func getCocktails(name: String) -> AnyPublisher<DrinkResponseData, Error> {
        return provider.request(target: .getCocktail(name: name))
            .catchAPIError()
            .decode(DrinkResponseData.self)   
    }
}

extension CocktailNetworkManager {

    struct DrinkResponseData: Codable {
        var data: [Cocktail]?
        
        enum CodingKeys: String, CodingKey {
            case data = "drinks"
        }
    }
}
