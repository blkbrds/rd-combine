//
//  Movie.swift
//  TheMovieCombineApp
//
//  Created by Toan Nguyen D. [4] VN.Danang on 31/07/2021.
//

import Foundation
import ObjectMapper

final class Movie: Mappable {

    var id: Int?
    var title: String?
    var poster: String?
    var year: String?
    var rate: Float?
    var overview: String?
    var voteAverage: Double?
    var voteCount: Int?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        id <- map["id"]
        title <- map["original_title"]
        rate <- map["vote_average"]
        year <- map["release_date"]
        poster <- map["poster_path"]
        overview <- map["overview"]
        voteAverage <- map["vote_average"]
        voteCount <- map["vote_count"]
        guard let posterMovie = poster else { return }
        poster = API.Path.baseImage + posterMovie
    }
}
