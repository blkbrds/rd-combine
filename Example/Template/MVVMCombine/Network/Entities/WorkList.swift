//
//  File.swift
//  MVVMCombine
//
//  Created by Van Le H. on 6/12/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation

final class WorkList: Decodable {
    var totalResults: Int
    var itemsPerPage: Int
    var works: [Work]
    var query: Query

    enum CodingKeys: String, CodingKey {
        case totalResults = "total-results"
        case itemsPerPage = "items-per-page"
        case works = "items"
        case query
    }
}
