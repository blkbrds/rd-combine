//
//  Cook.swift
//  FinalCombine
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 7/19/21.
//

import Foundation

struct Cook: Hashable, Decodable {

    let id: Int?
    let showId: Int?
    let name: String?
    let slug: String?
    let thumbnailUrl: String?
    let videoUrl: String?
    let instructions: [Instruction]?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case showId = "show_id"
        case name = "name"
        case slug = "slug"
        case thumbnailUrl = "thumbnail_url"
        case videoUrl = "video_url"
        case instructions = "instructions"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        showId = try container.decode(Int.self, forKey: .showId)
        name = try? container.decodeIfPresent(String.self, forKey: .name)
        slug = try? container.decodeIfPresent(String.self, forKey: .slug)
        thumbnailUrl = try? container.decodeIfPresent(String.self, forKey: .thumbnailUrl)
        id = try? container.decodeIfPresent(Int.self, forKey: .id)
        videoUrl = try? container.decodeIfPresent(String.self, forKey: .videoUrl)
        instructions = try? container.decodeIfPresent([Instruction].self, forKey: .instructions)
    }
}

