//
//  RestaurantDetailsViewModel.swift
//  Foody
//
//  Created by An Nguyễn on 05/05/2021.
//

import SwiftUI

final class RestaurantDetailsViewModel: ViewModel, ObservableObject {
    var restaurant: Restaurant = Restaurant()
    var products: [Product] = []
    var comments: [Comment] = []
    var id: String
    
    init(id: String = "") {
        self.id = id
        super.init()
        getRestaurantInfo()
    }
    
    func detailsViewModel(_ product: Product) -> ProductDetailsViewModel {
        ProductDetailsViewModel(id: product._id)
    }
    
    func getRestaurantInfo() {
        isLoading = true
        CustomerServices.getRestaurant(id: id)
            .zip(CustomerServices.getPopularProducts(restaurantId: id))
            .sink { (completion) in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.error = error
                }
            } receiveValue: { (restaurant, products) in
                self.restaurant = restaurant
                self.products = products
            }
            .store(in: &subscriptions)

    }
}
