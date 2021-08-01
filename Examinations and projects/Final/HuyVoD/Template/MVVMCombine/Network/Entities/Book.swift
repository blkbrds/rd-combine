//
//  Book.swift
//  MVVMCombine
//
//  Created by Huy Vo D. [2] VN.Danang on 7/30/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation

final class Book: Decodable, Hashable {
    
    var title: String?
    var subtitle: String?
    var isbn13: String?
    var price: String?
    var image: String?
    var url: String?
    var author: String?
    var publisher: String?
    var page: String?
    var year: String?
    var desc: String?
    var rating: String?

    enum CodingKeys: String, CodingKey {
        case title
        case subtitle
        case isbn13
        case price
        case image
        case url
        case author
        case publisher
        case page
        case year
        case desc
        case rating
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        isbn13 = try container.decodeIfPresent(String.self, forKey: .isbn13)
        price = try container.decodeIfPresent(String.self, forKey: .price)
        image = try container.decodeIfPresent(String.self, forKey: .image)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        author = try container.decodeIfPresent(String.self, forKey: .author)
        publisher = try container.decodeIfPresent(String.self, forKey: .publisher)
        page = try container.decodeIfPresent(String.self, forKey: .page)
        year = try container.decodeIfPresent(String.self, forKey: .year)
        desc = try container.decodeIfPresent(String.self, forKey: .desc)
        rating = try container.decodeIfPresent(String.self, forKey: .rating)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(isbn13)
    }
    
    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.isbn13 == rhs.isbn13
    }
}
