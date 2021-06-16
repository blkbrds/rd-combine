//
//  API.Response+Data.swift
//  CombineDemoError
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 6/11/21.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {

    let drinks: [T]

    private enum CodingKeys: String, CodingKey {
        case drinks
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        drinks = (try? container.decode([T].self, forKey: .drinks)).unwrapped(or: [])
    }
}
