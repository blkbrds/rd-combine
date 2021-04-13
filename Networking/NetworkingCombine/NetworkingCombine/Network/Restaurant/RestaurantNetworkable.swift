//
//  RestaurantNetworkable.swift
//  List-NavigationDemo
//
//  Created by MBA0321 on 3/5/21.
//

import Foundation
import Combine

typealias Parameters = [String: Any]

protocol RestaurantNetworkable {

    func getTrendings(page: Int) -> AnyPublisher<RestaurantNetworkManager.TrendingResponseData, Error>
    func getPopulars(page: Int) -> AnyPublisher<RestaurantNetworkManager.PopularResponseData, Error>
}
