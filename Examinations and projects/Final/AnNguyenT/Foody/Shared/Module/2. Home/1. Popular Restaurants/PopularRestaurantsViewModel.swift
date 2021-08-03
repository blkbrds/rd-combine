//
//  PopularRestaurantsViewModel.swift
//  Foody
//
//  Created by An Nguyễn on 05/05/2021.
//

import SwiftUI

final class PopularRestaurantsViewModel: ViewModel, ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var canLoadMore: Bool = false
    @Published var isLastRow: Bool = false
    @Published var currentPage: Int = 0
    
    override init() {
        super.init()
        
        getPopularRestaurants()
    }
    
    func detailsViewModel(_ restaurant: Restaurant) -> RestaurantDetailsViewModel {
        RestaurantDetailsViewModel(id: restaurant._id)
    }
    
    func getPopularRestaurants(page: Int = 0) {
        isLoading = true
        CustomerServices.popularRestaurants(page: page)
            .sink { (completion) in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.error = error
                }
            } receiveValue: { (res) in
                if res.page > 0 {
                    self.restaurants += res.restaurants
                } else {
                    self.restaurants = res.restaurants
                }
                self.currentPage = res.page
                self.canLoadMore = res.nextPage
            }
            .store(in: &subscriptions)
    }
    
    func handleLoadMore() {
        getPopularRestaurants(page: currentPage + 1)
    }
    
    func handleRefreshData() {
        restaurants.removeAll()
        canLoadMore = false
        currentPage = 0
        
        getPopularRestaurants()
    }
}
