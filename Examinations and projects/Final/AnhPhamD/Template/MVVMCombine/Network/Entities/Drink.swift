//
//  Drink.swift
//  MVVMCombine
//
//  Created by Anh Pham D.[2] VN.Danang on 7/21/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation

final class Drink: Codable, Hashable {

    var idDrink: String
    var drinkName: String
    var imageURL: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(idDrink)
    }

    static func == (lhs: Drink, rhs: Drink) -> Bool {
        return lhs.idDrink.elementsEqual(rhs.idDrink)
    }

    enum CodingKeys: String, CodingKey {
        case idDrink = "idDrink"
        case drinkName = "strDrink"
        case imageURL = "strDrinkThumb"
    }
}
