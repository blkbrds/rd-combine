//
//  Cocktail.swift
//  CombineExam
//
//  Created by MBA0242P on 5/9/21.
//

import Foundation

final class Cocktail: Codable {

    var idDrink: String = ""
    var strDrink: String = ""
    var strDrinkThumb: String = ""
    var strInstructions: String = ""

    enum CodingKeys: CodingKey {
        case idDrink
        case strDrink
        case strDrinkThumb
        case strInstructions
    }
}
