//
//  Cocktail.swift
//  CocktailChoose
//
//  Created by Thanh Nguyen X. [4] VN.Danang on 07/20/21.
//

import Foundation

final class Drinks: Codable, Identifiable {
    var cocktail: [Cocktail] = []

    enum CodingKeys: String, CodingKey {
        case cocktail = "drinks"
    }

    init() { }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cocktail = try container.decode([Cocktail].self, forKey: .cocktail)
    }
}

final class Cocktail: Codable, Identifiable {
    var id: String = ""
    var nameTitle: String = ""
    var imageURL: String = ""
    var instructions: String = ""

    enum CodingKeys: String, CodingKey {
        case nameTitle = "strDrink"
        case imageURL = "strDrinkThumb"
        case id = "idDrink"
        case instructions = "strInstructions"
    }

    init() { }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        nameTitle = try container.decode(String.self, forKey: .nameTitle)
        imageURL = try container.decode(String.self, forKey: .imageURL)
        instructions = try container.decode(String.self, forKey: .instructions)
    }
}
