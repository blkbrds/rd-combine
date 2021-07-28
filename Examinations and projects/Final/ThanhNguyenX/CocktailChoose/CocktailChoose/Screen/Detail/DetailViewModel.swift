//
//  DetailViewModel.swift
//  CocktailChoose
//
//  Created by Thanh Nguyen X. [4] VN.Danang on 07/20/21.
//

import Foundation

final class DetailViewModel: ViewModel {

    var cocktail: Cocktail?

    init(cocktail: Cocktail? = nil) {
        self.cocktail = cocktail
    }
}
