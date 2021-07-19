//
//  API.Response+Data.swift
//  FinalCombine
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 7/20/21.
//

import Foundation
struct APIResponse<T: Decodable>: Decodable {

    let results: [T]

    private enum CodingKeys: String, CodingKey {
       case results
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        results = (try container.decode([T].self, forKey: .results))
    }
}
