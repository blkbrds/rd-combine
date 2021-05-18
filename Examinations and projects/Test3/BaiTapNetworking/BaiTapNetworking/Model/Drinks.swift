//
//  Drinks.swift
//  BaiTapNetworking
//
//  Created by Trung Le D. on 5/7/21.
//

import Foundation
import Combine
struct Drinks: Decodable {
    let strDrink: String?

    static var placehoder: Drinks {
        return Drinks (strDrink: nil)
    }
}

struct DrinkRespond: Decodable {
    let drinks: [Drinks]
}
