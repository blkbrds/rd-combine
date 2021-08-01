//
//  DetailService.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/28/21.
//

import Foundation
import Combine
import ObjectMapper
import Alamofire

final class DetailService {

    class func getRelatedVideos(params: JSObject) -> AnyPublisher<([Video], String), AFError>  {
        let publisher = api.request(method: .get,
                                    path: ApiPath.playList,
                                    params: params).value()
        return publisher.map { data -> ([Video], String) in
            guard let jsonObject = data.toJSON() as? JSObject,
                  let nextPageToken = jsonObject["nextPageToken"] as? String,
                  let items = jsonObject["items"] as? JSArray else { return ([], "") }
            let videos = Mapper<Video>().mapArray(JSONArray: items)
            return (videos, nextPageToken)
        }.eraseToAnyPublisher()
    }

    class func getChannelInfo(params: JSObject) -> AnyPublisher<Channel, AFError>  {
        let publisher = api.request(method: .get,
                                    path: ApiPath.channel,
                                    params: params).value()
        return publisher.map { data -> Channel in
            guard let jsonObject = data.toJSON() as? JSObject,
                  let items = jsonObject["items"] as? JSArray,
                  let chanel = Mapper<Channel>().mapArray(JSONArray: items).first else { return Channel() }
            return chanel
        }.eraseToAnyPublisher()
    }

}
