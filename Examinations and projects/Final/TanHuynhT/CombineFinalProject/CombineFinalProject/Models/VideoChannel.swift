//
//  Channel.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/24/21.
//

import Foundation
import ObjectMapper

final class VideoChannel: NSObject, Mappable, Decodable {

    private(set) var id: String = ""
    private(set) var channelId: String = ""
    private(set) var channelTitle: String = ""

    convenience init?(map: Map) {
        self.init()
        id <- map["id"]
    }

    func mapping(map: Map) {
        channelId <- map["snippet.channelId"]
        channelTitle <- map["snippet.channelTitle"]
    }
}

