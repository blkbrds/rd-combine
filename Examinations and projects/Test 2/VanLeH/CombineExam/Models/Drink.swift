//
//  Drink.swift
//  CombineExam
//
//  Created by Van Le H. on 5/7/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation

struct Drinks: Decodable {
    var drinks: [Drink]
}

struct Drink: Decodable {
    var id: String
    var name: String
    var tags: String?

    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
        case tags = "strTags"
    }
}
