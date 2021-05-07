//
//  Cocktail.swift
//  BaiTap02
//
//  Created by Trin Nguyen X on 5/6/21.
//  Copyright © 2021 Trin Nguyen Xuan. All rights reserved.
//

import Foundation

final class Cocktail: Codable {

    var id: String = ""
    var nameTitle: String = ""
    var imageURL: String = ""
    var instructions: String = ""

    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case nameTitle = "strDrink"
        case imageURL = "strDrinkThumb"
        case instructions = "strInstructions"
    }
}
