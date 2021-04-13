//
//  Cocktail.swift
//  NetworkingCombine
//
//  Created by AnhPhamD. [2] on 4/12/21.
//

import Foundation

final class Cocktail: Codable, Identifiable {
    var id: String = ""
    var voteCount: Int = Int.random(in: 1...5)
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
