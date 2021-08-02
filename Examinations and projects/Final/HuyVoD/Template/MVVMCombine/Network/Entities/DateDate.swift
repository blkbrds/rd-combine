//
//  DateDate.swift
//  MVVMCombine
//
//  Created by Van Le H. on 6/12/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation

final class DateData: Decodable {
    var parts: [Int]?
    var dateTime: String?
    var timestamp: Int?

    enum CodingKeys: String, CodingKey {
        case parts = "date-parts"
        case dateTime = "date-time"
        case timestamp
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let partsArr: [[Int]]? = try container.decodeIfPresent([[Int]].self, forKey: .parts)
        parts = partsArr?.first
        dateTime = try container.decodeIfPresent(String.self, forKey: .dateTime)
        timestamp = try container.decodeIfPresent(Int.self, forKey: .timestamp)
    }
}
