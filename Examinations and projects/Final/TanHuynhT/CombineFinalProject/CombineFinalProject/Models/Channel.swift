//
//  Channel.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/27/21.
//

import Foundation
import ObjectMapper

final class Channel: NSObject, Mappable, Decodable {

    private(set) var id: String = ""
    private(set) var channelId: String = ""
    private(set) var channelTitle: String = ""
    private(set) var thumbnail: String = ""
    private(set) var subcriberCount: String = ""

    convenience init?(map: Map) {
        self.init()
        id <- map["id"]
    }

    func mapping(map: Map) {
        channelId <- map["snippet.channelId"]
        channelTitle <- map["snippet.title"]
        thumbnail <- map["snippet.thumbnails.high.url"]
        subcriberCount <- map["statistics.subscriberCount"]
    }
}
