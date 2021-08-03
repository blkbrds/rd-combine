//
//  RestaurantServices.swift
//  Foody
//
//  Created by MBA0283F on 5/18/21.
//

import Combine

struct ProductResponse: Decodable {
    var page: Int = 0
    var products: [Product] = []
    var nextPage: Bool = false
}

struct RestaurantsResponse: Decodable {
    var page: Int = 0
    var restaurants: [Restaurant] = []
    var nextPage: Bool = false
}

final class RestaurantServices {
    
    static func getProducts(page: Int = 0) -> AnyPublisher<ProductResponse, CommonError> {
        NetworkProvider.shared.request(.getProducts(page))
            .decode(type: ProductResponse.self)
            .eraseToAnyPublisher()
    }
    
    static func deleteProduct(id: String) -> AnyPublisher<Product, CommonError> {
        NetworkProvider.shared.request(.deleteProduct(id))
            .decode(type: Product.self)
            .eraseToAnyPublisher()
    }
    
    static func updateProduct(product: Product) -> AnyPublisher<Product, CommonError> {
        guard let params = try? product.toParameters() else {
            return Fail(error: .invalidInputData).eraseToAnyPublisher()
        }
        return NetworkProvider.shared.request(.updateProduct(params))
            .decode(type: Product.self)
            .eraseToAnyPublisher()
    }
    
    static func addNewProduct(product: Product) -> AnyPublisher<Product, CommonError> {
        guard let params = try? product.toParameters() else {
            return Fail(error: .invalidInputData).eraseToAnyPublisher()
        }
        return NetworkProvider.shared.request(.newProduct(params))
            .decode(type: Product.self)
            .eraseToAnyPublisher()
    }
    
    static func getOrders() -> AnyPublisher<[Order], CommonError> {
        NetworkProvider.shared.request(.getOrders)
            .decode(type: [Order].self)
            .eraseToAnyPublisher()
    }
    
    static func getChartsInfo(month: Int) -> AnyPublisher<[ChartResponse], CommonError>  {
        NetworkProvider.shared.request(.getChartInfo(month))
            .decode(type: [ChartResponse].self)
            .eraseToAnyPublisher()
    }
    
    static func addToBlacklist(_ warningUser: WarningUser) -> AnyPublisher<WarningUser, CommonError>   {
        guard let params = try? warningUser.toParameters() else {
            return Fail(error: .invalidInputData).eraseToAnyPublisher()
        }
        return NetworkProvider.shared.request(.blacklist(params))
            .decode(type: WarningUser.self)
            .eraseToAnyPublisher()
    }
    
    static func getBlacklist() -> AnyPublisher<[WarningUser], CommonError>   {
        return NetworkProvider.shared.request(.getBlacklist)
            .decode(type: [WarningUser].self)
            .eraseToAnyPublisher()
    }
}
