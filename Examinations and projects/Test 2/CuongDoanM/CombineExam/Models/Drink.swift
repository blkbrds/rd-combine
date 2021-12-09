//
//  Drink.swift
//  CombineExam
//
//  Created by Cuong Doan M. on 5/7/21.
//

import Foundation

struct Drink: Hashable, Decodable {
    
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
