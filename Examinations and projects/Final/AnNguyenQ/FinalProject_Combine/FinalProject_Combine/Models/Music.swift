//
//  Music.swift
//  FinalProject_Combine
//
//  Created by An Nguyen Q. VN.Danang on 7/7/21.
//

struct Music: Codable {
    var name: String
    var id: String
    var artistName: String
    var artworkUrl100: String
    var url: String
}

struct MusicResults: Codable {
    var results: [Music]
    var updated: String
}

struct FeedResults: Codable {
    var feed: MusicResults
}
