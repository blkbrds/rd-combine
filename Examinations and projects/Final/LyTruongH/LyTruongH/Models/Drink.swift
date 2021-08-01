//
//  Drink.swift
//  LyTruongH
//
//  Created by Ly Truong H. VN.Danang on 27/07/2021.
//

import Combine

struct Drink: Decodable {
    let strDrink: String?
    let strDrinkThumb: String?
    let strGlass: String?
}

struct Drinks: Decodable {
    let drinks: [Drink]
}
