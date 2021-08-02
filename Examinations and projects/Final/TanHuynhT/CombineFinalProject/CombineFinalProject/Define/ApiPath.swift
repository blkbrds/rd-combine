//
//  ApiPath.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/21/21.
//

import Foundation

final class ApiPath {

    static var baseURL: String = "https://www.googleapis.com/youtube/v3"
}

extension ApiPath {

    static var listRecommendVideos: String { return baseURL + "/videos" }
    static var search: String { return baseURL + "/search"}
    static var channel: String { return baseURL + "/channels"}
    static var playList: String { return baseURL + "/playlists"}
}
