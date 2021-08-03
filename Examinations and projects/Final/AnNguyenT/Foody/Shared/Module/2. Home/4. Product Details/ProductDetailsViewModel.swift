//
//  ProductDetailsViewModel.swift
//  Foody
//
//  Created by An Nguyễn on 05/05/2021.
//

import SwiftUI

final class ProductDetailsViewModel: ViewModel, ObservableObject {
    private var productId: String
    
    @Published var product = Product()
    @Published var comments: [Comment] = []
    @Published var keyboardHeight: CGFloat = 0
    @Published var commentText: String = ""

    var inValidComment: Bool {
        commentText.trimmed.isEmpty
    }
    
    var orderViewModel: OrderViewModel {
        OrderViewModel(product)
    }
    
    init(id: String = "") {
        self.productId = id
        super.init()
        getProductDetails()
        listenForKeyboardNotifications()
    }
    
    func refreshData() {
        getProductDetails()
    }
    
    func getProductDetails() {
        isLoading = true
        CommonServices.getProduct(id: productId)
            .zip(CommonServices.getComments(productId: productId))
            .sink { (completion) in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.error = error
                }
            } receiveValue: { (product, comments) in
                self.product = product
                self.comments = comments
            }
            .store(in: &subscriptions)
    }
    
    func voteProduct(vote: Int) {
        isLoading = true
        CustomerServices.voteProduct(id: product._id, voteCount: vote)
            .sink { (completion) in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.error = error
                }
            } receiveValue: { (product) in
                self.product = product
            }
            .store(in: &subscriptions)
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
    
    func comment() {
        guard let user = Session.shared.user else {
            error = .unknown("Can't get user information.")
            return
        }
        let comment = Comment(
            productId: product._id,
            userId: product.restaurantId,
            username: user.username,
            imageProfile: user.imageProfile,
            content: commentText.trimmed,
            voteCount: product.votes?[user._id]
        )
        isLoading = true
        CustomerServices.comment(id: product._id, comment: comment)
            .sink { (completion) in
                self.isLoading = false
                self.commentText = ""
                if case .failure(let error) = completion {
                    self.error = error
                }
            } receiveValue: { (comment) in
                self.comments.prepend(comment)
            }
            .store(in: &subscriptions)
    }
}

extension ProductDetailsViewModel {
    private func listenForKeyboardNotifications() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification,
                                               object: nil,
                                               queue: .main) { (notification) in
                                                guard let userInfo = notification.userInfo,
                                                    let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                                                
                                                self.keyboardHeight = keyboardRect.height
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification,
                                               object: nil,
                                               queue: .main) { (notification) in
                                                self.keyboardHeight = 0
        }
    }
}

