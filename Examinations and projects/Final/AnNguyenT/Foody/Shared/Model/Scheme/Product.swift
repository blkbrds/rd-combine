//
//  Product.swift
//  Foody
//
//  Created by An Nguyễn on 30/04/2021.
//

import Foundation

enum ProductType: String {
    case drink, food
}

enum ProductStatus: String {
    case accepted, none, rejected
}

struct Product: Codable {
    var _id: String = UUID.init().uuidString
    
    var restaurantId: String = ""
    
    var phoneNumber: String?
    
    var restaurantName: String = ""
    
    var imageBase64Encodings: [String] = []
    
    var voteCount: Int = 0
    
    var name: String = ""
    
    var price: Int = 0
    
    var descriptions: String = ""
        
    var type: String = ProductType.food.rawValue
    
    var orderCount: Int = 0
    
    var status: String = ProductStatus.none.rawValue
    
    var address: String = ""
    
    var votes: [String: Int]?
    
    var timeCreated: String? = Date().dateTimeString()
    
    ///
    var localImages: [Data]?
}

extension Product {
    var myVote: Int {
        votes?[Session.shared.user?._id ?? ""] ?? 0
    }
    
    var isDrink: Bool {
        type == ProductType.drink.rawValue
    }
    
    var accepted: Bool {
        status == ProductStatus.accepted.rawValue
    }
}

extension Product: Identifiable {
    /// Only for ui
    var id: String { _id }
}

extension Product: Hashable {
    static func ==(lhs: Product, rhs: Product?) -> Bool {
            return lhs._id == rhs?._id
        }

    func hash(into hasher: inout Hasher) {
        hasher.combine(_id)
    }
}

extension Product {
    var imageUrls: [String] {
        imageBase64Encodings
    }
    
    private var productImages: [Data] {
        imageBase64Encodings.compactMap({ Data(base64Encoded: $0) })
    }
    
    var isLiked: Bool {
        Session.shared.favorites.contains(self)
    }
}
