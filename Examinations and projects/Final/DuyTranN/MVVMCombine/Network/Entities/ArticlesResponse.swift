//
//  ArticlesResponse.swift
//  MVVMCombine
//
//  Created by Duy Tran on 7/27/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation

final class ArticlesResponse<T: Decodable>: Decodable {

    var status: String
    var totalResults: Int
    var articles: T

    enum CodingKeys: String, CodingKey {
        case status
        case totalResults
        case articles
    }
}
