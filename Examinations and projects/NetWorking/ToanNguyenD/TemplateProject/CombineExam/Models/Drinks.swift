//
//  Drinks.swift
//  CombineExam
//
//  Created by Toan Nguyen D. [4] on 5/6/21.
//

import Foundation

struct Drinks {
    let drinks: [Cocktail]
}

extension Drinks: Decodable {
    private enum CodingKeys: String, CodingKey {
        case drinks
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        drinks = try container.decode([Cocktail].self, forKey: .drinks)
    }
}
