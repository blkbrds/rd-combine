//
//  Province.swift
//  BaiTapNetworking
//
//  Created by Trin Nguyen X on 4/22/21.
//  Copyright © 2021 Trin Nguyen Xuan. All rights reserved.
//

import ObjectMapper
import Foundation

final class Province: Codable, Identifiable {

    // MARK: - Properties
    var name: String = ""

    enum CodingKeys: String, CodingKey {
        case name = "Title"
    }

    init() { }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
    }

}
