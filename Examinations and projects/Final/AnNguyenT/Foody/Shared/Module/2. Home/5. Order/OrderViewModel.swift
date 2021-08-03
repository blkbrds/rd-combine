//
//  OrderViewModel.swift
//  Foody
//
//  Created by MBA0283F on 5/10/21.
//

import SwiftUI

final class OrderViewModel: ViewModel, ObservableObject {
    private var order: Order = Order()
    @Published var isPresentedSuccessPopup = false
    @Published var address: String = ""
    @Published var itemCount: Int = 1
    
    var product: Product {
        order.product
    }
    
    var user: User {
        Session.shared.user ?? User()
    }
    
    var inValidInfo: Bool {
        address.isEmpty || !user.isActive
    }
    
    init(_ product: Product = Product()) {
        super.init()
        order.product = product
        address = user.address
    }
    
    func prepareOrderInfo() {
        order.username = user.username
        order.userId = user._id
        order.userProfile = user.imageProfile
        order.phoneNumber = user.phoneNumber
        order.address = address
        order.count = itemCount
        order.price = itemCount * product.price
    }
    
    func handleOrder() {
        prepareOrderInfo()
        
        isLoading = true
        CustomerServices.requestOrder(order)
            .sink { (completion) in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.error = error
                }
            } receiveValue: { (order) in
                self.isPresentedSuccessPopup = true
            }
            .store(in: &subscriptions)

    }
}

