//
//  Cocktail.swift
//  CombineExam
//
//  Created by Toan Nguyen D. [4] on 5/6/21.
//

import Foundation

struct Cocktail {
    var strDrink: String
    var strCategory: String
    let strDrinkThumb: String
}

extension Cocktail: Decodable {
    private enum CodingKeys: String, CodingKey {
        case strDrink
        case strCategory
        case strDrinkThumb
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        strDrink = try container.decode(String.self, forKey: .strDrink)
        strCategory = try container.decode(String.self, forKey: .strCategory)
        strDrinkThumb = try container.decode(String.self, forKey: .strDrinkThumb)
    }
}
