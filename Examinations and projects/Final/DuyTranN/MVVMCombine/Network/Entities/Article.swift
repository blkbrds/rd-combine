//
//  Article.swift
//  MVVMCombine
//
//  Created by Duy Tran on 7/27/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation

final class Article: Decodable, Hashable {

    var author: String
    var title: String
    var description: String
    var publishedAt: String
    var content: String

    enum CodingKeys: String, CodingKey {
        case author
        case title
        case description
        case publishedAt
        case content
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        author = try container.decodeIfPresent(String.self, forKey: .author).unwrapped(or: "")
        title = try container.decodeIfPresent(String.self, forKey: .title).unwrapped(or: "")
        description = try container.decodeIfPresent(String.self, forKey: .description).unwrapped(or: "")
        publishedAt = try container.decodeIfPresent(String.self, forKey: .publishedAt).unwrapped(or: "")
        content = try container.decodeIfPresent(String.self, forKey: .content).unwrapped(or: "")
    }

    public func hash(into hasher: inout Hasher) {
         hasher.combine(ObjectIdentifier(self))
    }

    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.publishedAt == rhs.publishedAt
    }
}
