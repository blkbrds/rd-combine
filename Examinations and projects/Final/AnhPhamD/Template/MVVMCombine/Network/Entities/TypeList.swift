//
//  Work.swift
//  MVVMCombine
//
//  Created by Van Le H. on 6/12/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation

final class TypeList: Decodable {
    var totalResults: Int
    var types: [Type]

    enum CodingKeys: String, CodingKey {
        case totalResults = "total-results"
        case types = "items"
    }
}
