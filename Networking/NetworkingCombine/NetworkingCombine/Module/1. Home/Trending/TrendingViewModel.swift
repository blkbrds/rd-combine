//
//  TrendingViewModel.swift
//  List-NavigationDemo
//
//  Created by MBA0283F on 3/10/21.
//

import Combine
import Foundation

final class TrendingViewModel: ObservableObject {
    // Network
    private var restaurantNetwork = RestaurantNetworkManager()
    
    @Published var isLoading: Bool = false
    @Published var trendingRestaurants: [Restaurant] = []
    
    var currentTrendingPageIndex: CurrentValueSubject<Int, Never> = .init(1)
    var subscriptions: Set<AnyCancellable> = []
    
    init() {
        currentTrendingPageIndex.sink { (page) in
            self.getTrendingRestaurants(page: page)
        }.store(in: &subscriptions)
    }
    
    func getTrendingRestaurants(page: Int) {
        guard !isLoading else { return }
        isLoading = true
        if page <= 1 {
            trendingRestaurants = []
        }
        restaurantNetwork.getTrendings(page: page < 1 ? 1: page)
            .sink(receiveCompletion: { error in
//                print("Error: \(error)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isLoading = false
                }
            }, receiveValue: { response in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.trendingRestaurants += response.data
                    self.isLoading = false
                }
            }).store(in: &subscriptions)
    }
    
    func getNextPages() {
        currentTrendingPageIndex.send(currentTrendingPageIndex.value + 1)
    }
    
    func refreshData() {
        currentTrendingPageIndex.send(1)
    }
}
