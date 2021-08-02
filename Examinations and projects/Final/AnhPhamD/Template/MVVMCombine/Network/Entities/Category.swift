//
//  Category.swift
//  MVVMCombine
//
//  Created by Anh Pham D.[2] VN.Danang on 7/23/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation

final class Category: Codable, Hashable {

    var strCategory: String

    enum CodingKeys: String, CodingKey {
        case strCategory = "strCategory"
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(strCategory)
    }

    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.strCategory.elementsEqual(rhs.strCategory)
    }
}
