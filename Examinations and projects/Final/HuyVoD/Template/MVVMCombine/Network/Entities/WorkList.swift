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

struct BookData: Decodable {
    var totalresults: String
    var currentPage: String?
    var books: [Book]
    
    enum CodingKeys: String, CodingKey {
        case totalresults = "total"
        case currentPage = "page"
        case books = "books"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalresults = try container.decode(String.self, forKey: .totalresults)
        books = try container.decode([Book].self, forKey: .books)
        currentPage = try container.decodeIfPresent(String.self, forKey: .currentPage)
    }

}
