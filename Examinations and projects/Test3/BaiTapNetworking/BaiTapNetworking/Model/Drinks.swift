//
//  Drinks.swift
//  BaiTapNetworking
//
//  Created by Trung Le D. on 5/7/21.
//

import Foundation
import Combine
struct Drinks: Decodable {
    let strAlcoholic: String?

    static var placehoder: Drinks {
        return Drinks (strAlcoholic: nil)
    }
}

struct DrinkRespond: Decodable {
    let drinks: [Drinks]
}
