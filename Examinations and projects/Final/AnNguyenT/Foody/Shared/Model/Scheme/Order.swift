//
//  Order.swift
//  Foody
//
//  Created by An Nguyễn on 01/05/2021.
//

import Foundation

enum OrderStatus: String {
    case pending, processing, shipping, paymented, canceled
}

struct Order: Codable {
    var _id: String = UUID.init().uuidString
    
    var userId: String = ""
    
    var username: String = ""
    
    var userProfile: String = ""
    
    var product: Product = Product()
    
    var count: Int = 0
    
    var status: String = OrderStatus.pending.rawValue
    
    var price: Int = 0
    
    var canceledReason: String?
    
    var orderTime: String = Date().dateTimeString()
    
    var shippingTime: String = ""
    
    var canceledTime: String = ""
    
    var paymentedTime: String = ""
    
    var address: String = ""
    
    var phoneNumber: String = ""
    
    var month: Int = Date().month
    
}

extension Order: Identifiable {
    var id: String { _id }
    
    var time: String {
        switch status {
        case OrderStatus.canceled.rawValue:
            return canceledTime
        case OrderStatus.processing.rawValue:
            return shippingTime
        case OrderStatus.paymented.rawValue:
            return paymentedTime
        default:
            return ""
        }
    }
    
    var isCanceled: Bool {
        status == OrderStatus.canceled.rawValue
    }
    
    var isProcessing: Bool {
        status == OrderStatus.processing.rawValue
    }
    
    var isShipping: Bool {
        status == OrderStatus.shipping.rawValue
    }
    
    var isPending: Bool {
        status == OrderStatus.pending.rawValue
    }
    
    var paymented: Bool {
        status == OrderStatus.paymented.rawValue
    }
    
    var canceledByUser: Bool {
        canceledReason?.contains("user") == true
    }
}

extension Order: Hashable {
    static func ==(lhs: Order, rhs: Order?) -> Bool {
            return lhs._id == rhs?._id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(_id)
    }
}

struct ChartResponse: Decodable {
    var month: Int
    var shippingTime: String
    var count: Int
    var price: Int
    var paymentedTime: String
    var orderTime: String
    var status: String
    var canceledTime: String
    
    var orderDate: Date {
        orderTime.date(withFormat: "dd MM yyyy 'at' HH:mm:ss") ?? Date()
    }
}
