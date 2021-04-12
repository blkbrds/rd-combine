//
//  Cocktail.swift
//  NetworkingCombine
//
//  Created by AnhPhamD. [2] on 4/12/21.
//

import Foundation

final class Cocktail: Codable {
    var nameTitle: String = ""
    var imageURL: String = ""

    enum CodingKeys: String, CodingKey {
        case nameTitle = "strDrink"
        case imageURL = "strDrinkThumb"
    }

    init(nameTilte: String, imageURL: String) {
        self.nameTitle = nameTitle
        self.imageURL = imageURL
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        nameTitle = try container.decode(String.self, forKey: .nameTitle)
        imageURL = try container.decode(String.self, forKey: .imageURL)
    }
}
