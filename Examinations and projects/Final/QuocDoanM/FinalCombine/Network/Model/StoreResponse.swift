//
//  StoreResponse.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/30/21.
//

import UIKit

class StoreResult: Codable {
    var id: Int = 0
    var name: String = ""
    var domain: String? = ""
    var slug: String = ""
    var gameCount: Int? = 0
    var imgBackground: String? = ""
    var description: String?
    var games: [Game]?

    enum CodingKeys: String, CodingKey {
        case id, name, domain, slug, description, games
        case gameCount = "games_count"
        case imgBackground = "image_background"
    }
}

class Game: Codable {
    var id: Int = 0
    var slug: String = ""
    var name: String = ""
    var added: Int = 0
}
