//
//  Instruction.swift
//  FinalCombine
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 7/20/21.
//

import Foundation

struct Instruction: Hashable, Decodable {

    let id: Int?
    let displayText: String?
    let position: Int?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case displayText = "display_text"
        case position = "position"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try? container.decodeIfPresent(Int.self, forKey: .id)
        displayText = try? container.decodeIfPresent(String.self, forKey: .displayText)
        position = try? container.decodeIfPresent(Int.self, forKey: .position)
    }
}
