//
//  Query.swift
//  MVVMCombine
//
//  Created by Van Le H. on 6/12/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation

final class Query: Decodable {
    var currentPage: Int
    var searchTerms: String?

    enum CodingKeys: String, CodingKey {
        case currentPage = "start-index"
        case searchTerms = "search-terms"
    }
}
