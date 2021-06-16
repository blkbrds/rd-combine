//
//  Drink.swift
//  CombineDemoError
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 6/11/21.
//

import Foundation

//struct Drink: Hashable, Decodable {
//    var drinks: [Drink] = []
//    let id: String
//    let drink: String?
//    let instructions: String?
//    let thumb: String?
//    let modified: Date?
//
//    private enum CodingKeys: String, CodingKey {
//        case id = "idDrink"
//        case drink = "strDrink"
//        case instructions = "strInstructions"
//        case thumb = "strDrinkThumb"
//        case modified = "dateModified"
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(String.self, forKey: .id)
//        drink = try? container.decodeIfPresent(String.self, forKey: .drink)
//        instructions = try? container.decodeIfPresent(String.self, forKey: .instructions)
//        thumb = try? container.decodeIfPresent(String.self, forKey: .thumb)
//        modified = try? container.decodeIfPresent(Date.self, forKey: .modified)
//    }
//}

struct Drinks: Codable {
    var drinks: [Drink] = []

    enum CodingKeys: String, CodingKey {
        case drinks = "drinks"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        drinks = try container.decode([Drink].self, forKey: .drinks)
    }
}

struct Drink: Codable {
    let id: String
    let drink: String?
    let instructions: String?
    let thumb: String?
    let modified: Date?

    private enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case drink = "strDrink"
        case instructions = "strInstructions"
        case thumb = "strDrinkThumb"
        case modified = "dateModified"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        drink = try? container.decodeIfPresent(String.self, forKey: .drink)
        instructions = try? container.decodeIfPresent(String.self, forKey: .instructions)
        thumb = try? container.decodeIfPresent(String.self, forKey: .thumb)
        modified = try? container.decodeIfPresent(Date.self, forKey: .modified)
    }
}
