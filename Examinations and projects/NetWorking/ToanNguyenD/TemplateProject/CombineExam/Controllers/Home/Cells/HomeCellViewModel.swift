//
//  HomeViewModel.swift
//  CombineExam
//
//  Created by Toan Nguyen D. [4] on 4/14/21.
//

import Foundation
import Combine

final class HomeCellViewModel {

    var name: String = ""
    var category: String = ""
    var thumbnailURL: String = ""
    private let cocktail: Cocktail

    init(cocktail: Cocktail) {
        self.cocktail = cocktail
        name = cocktail.strDrink
        category = cocktail.strCategory
        thumbnailURL = cocktail.strDrinkThumb
    }
}
