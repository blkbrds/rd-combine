//
//  HomeServices.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/21/21.
//

import Foundation
import Combine
import ObjectMapper
import Alamofire

final class HomeService {

    class func getRecommendVideos(params: JSObject) -> AnyPublisher<([Video], String), AFError>  {
        let publisher = api.request(method: .get,
                                    path: ApiPath.listRecommendVideos,
                                    params: params).value()
        return publisher.map { data -> ([Video], String) in
            guard let jsonObject = data.toJSON() as? JSObject,
                  let nextPageToken = jsonObject["nextPageToken"] as? String,
                  let items = jsonObject["items"] as? JSArray else { return ([], "") }
            let videos = Mapper<Video>().mapArray(JSONArray: items)
            return (videos, nextPageToken)
        }.eraseToAnyPublisher()
    }

    class func getChannels(params: JSObject) -> AnyPublisher<[VideoChannel], AFError>  {
        let publisher = api.request(method: .get,
                                    path: ApiPath.search,
                                    params: params).value()
        return publisher.map { data -> [VideoChannel] in
            guard let jsonObject = data.toJSON() as? JSObject,
                  let items = jsonObject["items"] as? JSArray else { return [] }
            let chanels = Mapper<VideoChannel>().mapArray(JSONArray: items)
            return chanels
        }.eraseToAnyPublisher()
    }
}
