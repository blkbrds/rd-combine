//
//  PopularRestaurantsViewModel.swift
//  Foody
//
//  Created by An Nguyễn on 05/05/2021.
//

import SwiftUI

final class TrendingProductsViewModel: ViewModel, ObservableObject {
    @Published var products: [Product] = []
    @Published var canLoadMore: Bool = false
    @Published var isLastRow: Bool = false
    @Published var currentPage: Int = 0
    
    override init() {
        super.init()
        
        getTrendingProducts()
    }
    
    func detailsViewModel(_ product: Product) -> ProductDetailsViewModel {
        ProductDetailsViewModel(id: product._id)
    }
    
    func getTrendingProducts(page: Int = 0) {
        isLoading = true
        CustomerServices.trendingProducts(page: page)
            .sink { (completion) in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.error = error
                }
            } receiveValue: { (res) in
                if res.page > 0 {
                    self.products += res.products
                } else {
                    self.products = res.products
                }
                self.currentPage = res.page
                self.canLoadMore = res.nextPage
            }
            .store(in: &subscriptions)
    }
    
    func handleLoadMore() {
        getTrendingProducts(page: currentPage + 1)
    }
    
    func handleRefreshData() {
        products.removeAll()
        canLoadMore = false
        currentPage = 0
        
        getTrendingProducts()
    }
    
    func addToFavorite(_ product: Product) {
        guard let userId = Session.shared.user?._id else {
            error = .unknown("Can't get user id.")
            return
        }
        let item = FavoriteItemResponse(_id: UUID.init().uuidString, userId: userId, product: product)
        isLoading = true
        CustomerServices.addNewFavorie(item)
            .sink { (completion) in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.error = error
                }
            } receiveValue: { (res) in
                Session.shared.favorites.append(res.product)
            }
            .store(in: &subscriptions)
    }
    
    func deleteInFavorite(_ product: Product) {
        isLoading = true
        CustomerServices.deleteFavorite(productId: product._id)
            .sink { (completion) in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.error = error
                }
            } receiveValue: { (res) in
                Session.shared.favorites.removeAll(product)
            }
            .store(in: &subscriptions)
    }
}
