//
//  CustomerServices.swift
//  Foody
//
//  Created by MBA0283F on 5/18/21.
//

import Combine

struct FavoriteItemResponse: Codable {
    var _id: String
    var userId: String
    var product: Product
}

final class CustomerServices {
    
    static func requestOrder(_ order: Order) -> AnyPublisher<Order, CommonError> {
        guard let params = try? order.toParameters() else {
            return Fail(error: CommonError.invalidInputData)
                .eraseToAnyPublisher()
        }
        return NetworkProvider.shared.request(.requestOrder(params))
            .decode(type: Order.self)
            .eraseToAnyPublisher()
    }

    static func cancelOrder(id: String, reason: String = "") -> AnyPublisher<Order, CommonError> {
        NetworkProvider.shared.request(.cancelOrder(id))
            .decode(type: Order.self)
            .eraseToAnyPublisher()
    }
    
    static func popularRestaurants(page: Int = 0) -> AnyPublisher<RestaurantsResponse, CommonError> {
        NetworkProvider.shared.request(.popularRestaurants(page))
            .decode(type: RestaurantsResponse.self)
            .eraseToAnyPublisher()
    }
    
    static func trendingProducts(page: Int = 0) -> AnyPublisher<ProductResponse, CommonError> {
        NetworkProvider.shared.request(.trendingProducts(page))
            .decode(type: ProductResponse.self)
            .eraseToAnyPublisher()
    }
    
    static func voteRestaurant(id: String,  voteCount: Int) -> AnyPublisher<Restaurant, CommonError> {
        NetworkProvider.shared.request(.voteRestaurant(id, voteCount))
            .decode(type: Restaurant.self)
            .eraseToAnyPublisher()
    }
    
    static func voteProduct(id: String,  voteCount: Int) -> AnyPublisher<Product, CommonError> {
        NetworkProvider.shared.request(.voteProduct(id, voteCount))
            .decode(type: Product.self)
            .eraseToAnyPublisher()
    }
    
    static func comment(id: String,  comment: Comment) -> AnyPublisher<Comment, CommonError> {
        guard let params = try? comment.toParameters() else {
            return Fail(error: CommonError.invalidInputData).eraseToAnyPublisher()
        }
        return NetworkProvider.shared.request(.comment(id, params))
            .decode(type: Comment.self)
            .eraseToAnyPublisher()
    }
}

// Favorites
extension CustomerServices {
    
    static func getFavoriteProducts() -> AnyPublisher<[FavoriteItemResponse], CommonError> {
        NetworkProvider.shared.request(.getFavorites)
            .decode(type: [FavoriteItemResponse].self)
            .eraseToAnyPublisher()
    }
    
    static func deleteFavorite(productId: String) -> AnyPublisher<FavoriteItemResponse?, CommonError> {
        NetworkProvider.shared.request(.deleteFavorite(productId))
            .decode(type: FavoriteItemResponse?.self)
            .eraseToAnyPublisher()
    }
    
    static func addNewFavorie(_ item: FavoriteItemResponse) -> AnyPublisher<FavoriteItemResponse, CommonError> {
        guard let params = try? item.toParameters() else {
            return Fail(error: CommonError.invalidInputData).eraseToAnyPublisher()
        }
        return NetworkProvider.shared.request(.newFavorite(params))
            .decode(type: FavoriteItemResponse.self)
            .eraseToAnyPublisher()
    }
}

extension CustomerServices {
    
    static func getRestaurant(id: String) -> AnyPublisher<Restaurant, CommonError> {
        NetworkProvider.shared.request(.getRestaurant(id))
            .decode(type: Restaurant.self)
            .eraseToAnyPublisher()
    }
    
    static func getPopularProducts(restaurantId: String) -> AnyPublisher<[Product], CommonError> {
        NetworkProvider.shared.request(.popularProducts(restaurantId))
            .decode(type: [Product].self)
            .eraseToAnyPublisher()
    }
}
