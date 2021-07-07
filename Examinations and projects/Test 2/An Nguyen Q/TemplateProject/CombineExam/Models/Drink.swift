//
//  Drink.swift
//  CombineExam
//
//  Created by MBA0217 on 4/28/21.
//

import Foundation

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
    var idDrink: String = ""
    var strDrink: String = ""
    var strCategory: String = ""

    enum CodingKeys: String, CodingKey {
        case idDrink = "idDrink"
        case strDrink = "strDrink"
        case strCategory = "strCategory"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        idDrink = try container.decode(String.self, forKey: .idDrink)
        strDrink = try container.decode(String.self, forKey: .strDrink)
        strCategory = try container.decode(String.self, forKey: .strCategory)
    }
}
