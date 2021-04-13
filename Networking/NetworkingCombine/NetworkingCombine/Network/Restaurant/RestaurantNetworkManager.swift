//
//  RestaurantNetworkManager.swift
//  NetworkingCombine
//
//  Created by MBP0051 on 4/13/21.
//

import Combine

final class RestaurantNetworkManager: RestaurantNetworkable {

    var provider: Provider<RestauranService> = Provider<RestauranService>()

    func getTrendings(page: Int) -> AnyPublisher<TrendingResponseData, Error> {
        return provider.requestWithTarget(target: .trendings(page: page))
            .catchAPIError()
            .decode(TrendingResponseData.self)
        
    }
    
    func getPopulars(page: Int) -> AnyPublisher<PopularResponseData, Error> {
        return provider.requestWithTarget(target: .populars(page: page))
            .catchAPIError()
            .decode(PopularResponseData.self)
    }
}

extension RestaurantNetworkManager {

    struct PopularResponseData: Codable {
        var data: [Restaurant]
        
        enum CodingKeys: String, CodingKey {
            case data = "ads"
        }
    }
    
    struct TrendingResponseData: Codable {
        var data: [Restaurant]
        
        enum CodingKeys: String, CodingKey {
            case data = "ads"
        }
    }
}
