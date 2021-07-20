//
//  Work.swift
//  MVVMCombine
//
//  Created by Van Le H. on 6/12/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation

final class Work: Decodable, Hashable {

    var id: String
    var title: String
    var issued: DateData?
    var publisher: String?

    enum CodingKeys: String, CodingKey {
        case id = "DOI"
        case title
        case issued
        case publisher
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        let titleArr: [String] = try container.decodeIfPresent([String].self, forKey: .title) ?? []
        title = titleArr.first.content
        issued = try container.decodeIfPresent(DateData.self, forKey: .issued)
        publisher = try container.decodeIfPresent(String.self, forKey: .publisher)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Work, rhs: Work) -> Bool {
        return lhs.id.elementsEqual(rhs.id)
    }
}
