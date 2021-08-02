//
//  GameDetailResponse.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/31/21.
//

import UIKit

struct GameDetailResponse: Codable {
    var id: Int? = 0
    var name: String? = ""
    var stores: [ParentStore]?
    var released: String? = ""
    var updated: String? = ""
    var backgroundImage: String? = ""
    var website: String? = ""
    var rating: Double? = 0
    var developers: [Developer]?
    var tags: [GameImage]?
    var screenShot: [ScreenShoot]?
    var genres: [Genre]?

    private enum CodingKeys: String, CodingKey {
        case id, name, stores, released, updated, website, rating, developers, tags, genres
        case backgroundImage = "background_image"
        case screenShot = "short_screenshots"
    }
}

struct Developer: Codable {
    var id: Int = 0
    var name: String = ""
    var gameCount: Int = 0
    var imageBackground: String = ""

    private enum CodingKeys: String, CodingKey {
        case id, name
        case gameCount = "games_count"
        case imageBackground = "image_background"
    }
}

struct GameImage: Codable {
    var id: Int = 0
    var name: String = ""
    var imageBackground: String = ""

    private enum CodingKeys: String, CodingKey {
        case id, name
        case imageBackground = "image_background"
    }
}

struct ScreenShoot: Codable {
    var id: Int = 0
    var image: String = ""
}

struct Genre: Codable {
    var id: Int = 0
    var name: String = ""
}

struct ParentStore: Codable {
    var store: StoreResult?
}
