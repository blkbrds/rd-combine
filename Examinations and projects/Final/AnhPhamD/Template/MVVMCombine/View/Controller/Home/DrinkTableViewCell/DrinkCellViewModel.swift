//
//  DrinkCellViewModel.swift
//  MVVMCombine
//
//  Created by Anh Pham D.[2] VN.Danang on 7/22/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation

final class DrinkCellViewModel {

    var idDrink: String
    var drinkName: String
    var imageURL: String

    init(idDrink: String, drinkName: String, imageURL: String) {
        self.idDrink = idDrink
        self.drinkName = drinkName
        self.imageURL = imageURL
    }
}
