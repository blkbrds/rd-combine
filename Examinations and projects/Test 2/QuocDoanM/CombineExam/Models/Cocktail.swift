//
//  Cocktail.swift
//  CombineExam
//
//  Created by Quoc Doan M. on 5/7/21.
//

import UIKit

struct CocktailsResponse: Codable {

    let drinks: [Cocktail]

    private enum CodingKeys: String, CodingKey {
        case drinks = "drinks"
    }
}

struct Cocktail: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let imageURL: String
    let instructions: String

    private enum CodingKeys: String, CodingKey {
        case id = "idDrink", name = "strDrink", imageURL = "strDrinkThumb", instructions = "strInstructions"
    }
}
