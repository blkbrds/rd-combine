//
//  Drink.swift
//  CombineExam
//
//  Created by Ly Truong H on 18/05/2021.
//

import Combine

struct Drink: Decodable {
    let strDrink: String?
}

struct Drinks: Decodable {
    let drinks: [Drink]
}
