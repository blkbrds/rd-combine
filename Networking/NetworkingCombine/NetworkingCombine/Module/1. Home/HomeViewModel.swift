//
//  HomeViewModel.swift
//  List-NavigationDemo
//
//  Created by MBA0321 on 3/5/21.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    // Network
    private let restaurantNetwork = RestaurantNetworkManager()

    @Published var trendingRestaurants: [Restaurant] = []
    @Published var popularRestaurants: [Restaurant] = []
    @Published var isShowing = false
    @Published var canLoadMore: Bool = true
    @Published var hasScroll: Bool = false

    let currentPopularPageIndex: CurrentValueSubject<Int, Never> = .init(1)
    let currentTrendingPageIndex: CurrentValueSubject<Int, Never> = .init(1)
    var stores: Set<AnyCancellable> = []
    
    init() {
        currentTrendingPageIndex.flatMap {
            self.restaurantNetwork.getTrendings(page: $0)
        }.sink { error in
            print(error)
        } receiveValue: { value in
            self.trendingRestaurants = value.data
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isShowing = false
            }
        }.store(in: &stores)
        
        currentPopularPageIndex.flatMap {
            self.restaurantNetwork.getPopulars(page: $0)
        }.sink { error in
            print(error)
        } receiveValue: { value in
            if self.currentPopularPageIndex.value == 1 {
                self.popularRestaurants = value.data
            } else {
                self.popularRestaurants += value.data
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isShowing = false
            }
        }.store(in: &stores)
    }
    
    func checkPopuplarLoadmoreNeeded(_ res: Restaurant) {
        let thresholdIndex = popularRestaurants.index(popularRestaurants.endIndex, offsetBy: -1)
        if popularRestaurants.firstIndex(where: { $0.id == res.id }) == thresholdIndex {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.currentPopularPageIndex.send(self.currentPopularPageIndex.value + 1)
            }
        }
    }
}
