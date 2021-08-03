//
//  HomeViewModel.swift
//  Foody
//
//  Created by An Nguyễn on 04/05/2021.
//

import SwiftUI

final class HomeViewModel: ViewModel, ObservableObject {
    var trendingProducts: [Product] = []
    var popularRestaurants: [Restaurant] = []
    
    override var tabIndex: Int? { 0 }
    
    override func setupData() {
        getHomeData()
    }
    
    func foodDetailViewModel(_ product: Product) -> ProductDetailsViewModel {
        ProductDetailsViewModel(id: product._id)
    }
    
    func restaurantDetailViewModel(_ restaurant: Restaurant) -> RestaurantDetailsViewModel {
        RestaurantDetailsViewModel(id: restaurant._id)
    }
    
    func loginFirebase() {
        FirebaseTask.loginFirebase()
            .sink { (completion) in
                print(completion)
            } receiveValue: { (value) in
                print("DEBUG - LOGIN FIREBASE SUCCESS")
            }
            .store(in: &subscriptions)
    }
    
    func getHomeData() {
        isLoading = true
        CustomerServices.popularRestaurants()
            .zip(CustomerServices.trendingProducts(), CustomerServices.getFavoriteProducts(), CommonServices.getNotifications())
            .sink { (completion) in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.error = error
                }
            } receiveValue: { (res1, res2, res3, res4) in
                self.popularRestaurants = res1.restaurants
                self.trendingProducts = res2.products
                Session.shared.favorites = res3.map({ $0.product })
                Session.shared.haveNotifications = res4.contains(where: { $0.isRead == false })
            }
            .store(in: &subscriptions)
    }
    
    func refreshData() {
        trendingProducts.removeAll()
        popularRestaurants.removeAll()
        
        getHomeData()
    }
}
