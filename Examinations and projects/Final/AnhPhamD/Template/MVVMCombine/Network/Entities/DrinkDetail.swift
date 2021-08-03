//
//  DrinkDetail.swift
//  MVVMCombine
//
//  Created by Anh Pham D.[2] VN.Danang on 8/3/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation

final class DrinkDetail: Codable {

    var strCategory: String
    var strAlcoholic: String
    var strGlass: String
    var imageURL: String

    enum CodingKeys: String, CodingKey {
        case strCategory = "strCategory"
        case strAlcoholic = "strAlcoholic"
        case strGlass = "strGlass"
        case imageURL = "strDrinkThumb"
    }
}
