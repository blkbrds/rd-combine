//
//  Drink.swift
//  BaiTapNetworking
//
//  Created by Trung Le D. on 5/7/21.
//

import Foundation
import Combine
struct Drink: Decodable {
    let strAlcoholic: String?

    static var placehoder: Drink {
        return Drink(strAlcoholic: nil)
    }
}

struct DrinkRespond: Decodable {
    let main: Drink
}
