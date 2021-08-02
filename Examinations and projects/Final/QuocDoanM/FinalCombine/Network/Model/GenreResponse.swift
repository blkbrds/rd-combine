//
//  GenreResponse.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/29/21.
//

import UIKit

struct GenreResult: Decodable {
    var count: Int = 0
//    var next: String = ""
//    var previous: String = ""
    var results: [GenreGame]
}

struct GenreGame: Decodable, Hashable {
    var id: Int
    var name: String = ""
    var slug: String = ""
    var gameCount: Int = 0
    var imageURL: String = ""
    var games: [Game]

    enum CodingKeys: String, CodingKey {
        case id, name, slug, games
        case gameCount = "games_count"
        case imageURL = "image_background"
    }
}

struct Game: Decodable, Hashable {
    var id: Int = 0
    var slug: String = ""
    var name: String = ""
    var added: Int = 0
}
