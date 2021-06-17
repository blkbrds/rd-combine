//
//  User.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation

struct User {
    var id: String = UUID().uuidString
    var name: String
    var address: String
    var password: String = "12345678"
}

struct Drink: Codable {
    let strGlass: String
    let strTags: String
    
    private enum CodingKeys: String, CodingKey {
        case strGlass = "strGlass"
        case strTags = "strTags"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.strGlass = try container.decodeIfPresent(String.self, forKey: .strGlass) ?? ""
        self.strTags = try container.decodeIfPresent(String.self, forKey: .strTags) ?? ""
    }
}

struct DrinksRespone: Codable {
    let drinks: [Drink]
    
    private enum CodingKeys: String, CodingKey {
            case drinks = "drinks"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.drinks = try container.decodeIfPresent([Drink].self, forKey: .drinks) ?? []
    }
}
