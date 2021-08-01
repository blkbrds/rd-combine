//
//  SearchService.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/24/21.
//

import Foundation
import Combine
import Alamofire
import ObjectMapper

final class SearchService {

    class func searchVideos(params: JSObject) -> AnyPublisher<([Video], String), AFError>  {
        let publisher = api.request(method: .get,
                                    path: ApiPath.search,
                                    params: params).value()

        return publisher.map { data -> ([Video], String) in
            guard let jsonObject = data.toJSON() as? JSObject,
                  let nextPageToken = jsonObject["nextPageToken"] as? String,
                  let items = jsonObject["items"] as? JSArray else { return ([], "") }
            let videos = Mapper<Video>().mapArray(JSONArray: items)
            return (videos, nextPageToken)
        }.eraseToAnyPublisher()
    }
}
