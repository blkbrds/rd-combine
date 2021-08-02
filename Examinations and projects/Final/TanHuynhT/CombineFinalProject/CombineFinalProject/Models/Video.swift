//
//  Video.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/21/21.
//

import Foundation
import ObjectMapper

final class Video: NSObject, Mappable, Decodable {

    private(set) var id: String = ""
    private(set) var channelId: String = ""
    private(set) var channelTitle: String = ""
    private(set) var title: String = ""
    private(set) var viewCount: Int = 0
    private(set) var publishedAt: Date = Date()
    private(set) var thumbnail: String = ""

    convenience init?(map: Map) {
        self.init()
        id <- map["id"]
    }

    func mapping(map: Map) {
        channelId <- map["snippet.channelId"]
        channelTitle <- map["snippet.channelTitle"]
        title <- map["snippet.title"]
        viewCount <- map["statistics.viewCount"]
        publishedAt <- map["statistics.publishedAt"]
        thumbnail <- map["snippet.thumbnails.high.url"]
    }
}
