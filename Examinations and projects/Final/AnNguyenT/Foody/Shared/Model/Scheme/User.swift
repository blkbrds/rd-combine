//
//  User.swift
//  Foody
//
//  Created by An Nguyễn on 4/13/21.
//

import Foundation
import SwiftyUserDefaults

enum UserType: String {
    case customer, restaurant
    
    var isCustomer: Bool {
        self == .customer
    }
    
    var isRestaurant: Bool {
        self == .restaurant
    }
}

enum AccountStatus: String {
    case blocked, active
}

struct User: Codable, UserInfomation, DefaultsSerializable {
    var _id: String = UUID.init().uuidString
        
    var username: String = ""
    
    var age: Int = 0
    
    var imageProfile: String = ""
    
    var email: String = ""
        
    var phoneNumber: String = ""
    
    var address: String = ""
    
    var gender: Bool = false
    
    var type: String = UserType.customer.rawValue
    
    var timeCreated: String = Date().dateTimeString()
    
    var status: String = AccountStatus.active.rawValue // Account status
}

extension User {
    var isActive: Bool {
        status == AccountStatus.active.rawValue
    }
    
}


struct WarningUser: Codable {
    var _id: String = UUID.init().uuidString
    var userId: String
    var time: String
    var restaurantId: String
    var productId: String
}
