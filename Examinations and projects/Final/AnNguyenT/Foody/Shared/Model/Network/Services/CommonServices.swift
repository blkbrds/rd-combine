//
//  ProductServices.swift
//  Foody
//
//  Created by MBA0283F on 5/10/21.
//

import Combine

final class CommonServices {
    static func getProduct(id: String) -> AnyPublisher<Product, CommonError> {
        NetworkProvider.shared.request(.getProduct(id))
            .decode(type: Product.self)
            .eraseToAnyPublisher()
    }
    
    static func getComments(productId: String) -> AnyPublisher<[Comment], CommonError> {
        NetworkProvider.shared.request(.getComments(productId))
            .decode(type: [Comment].self)
            .eraseToAnyPublisher()
    }
    
    // Search by restaurant (id) / customer (all)
    static func searchProducts(productName: String, page: Int = 0) -> AnyPublisher<ProductResponse, CommonError> {
        NetworkProvider.shared.request(.searchProducts(productName: productName, page: page))
            .decode(type: ProductResponse.self)
            .eraseToAnyPublisher()
    }
    
    static func getNotifications() -> AnyPublisher<[Notifications], CommonError> {
        NetworkProvider.shared.request(.getNotifications)
            .decode(type: [Notifications].self)
            .eraseToAnyPublisher()
    }
    
    static func markReadNotification(id: String) -> AnyPublisher<Notifications, CommonError> {
        NetworkProvider.shared.request(.readNotification(id: id))
            .decode(type: Notifications.self)
            .eraseToAnyPublisher()
    }
    
    static func verifyOrder(_ params: Parameters) -> AnyPublisher<Order, CommonError> {
        NetworkProvider.shared.request(.verifyOrder(params))
            .decode(type: Order.self)
            .eraseToAnyPublisher()
    }
    
    static func getKeywords(text: String) -> AnyPublisher<[Keyword], CommonError> {
        NetworkProvider.shared.request(.getKeywords(text))
            .decode(type: [Keyword].self)
            .eraseToAnyPublisher()
    }
}
