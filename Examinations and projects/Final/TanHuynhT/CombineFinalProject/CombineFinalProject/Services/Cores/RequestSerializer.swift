//
//  RequestSerializer.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/22/21.
//

import Foundation
import Alamofire
import Combine

extension ApiManager {

    var defaultHTTPHeaders: [String: String] {
        return HTTPHeaders.default.dictionary
    }

    @discardableResult
    func request(
        method: HTTPMethod,
        path: URLStringConvertible,
        params: JSObject? = nil,
        header: [String: String]? = nil
    ) -> DataResponsePublisher<Data> {

        let params = params ?? Parameters()
        let encode: ParameterEncoding = {
            switch method {
            case .get, .delete: return URLEncoding.default
            default: return JSONEncoding.default
            }
        }()

        var defaultHeader: [String: String] = [:]
        if let header = header {
            defaultHeader = header
        } else {
            defaultHeader = defaultHTTPHeaders
        }

        var parameters = params
//        let keyAPI: [String: String] = ["key": "AIzaSyCq4KjQz1TOqqO1JkaBzA0vhyxjR93ERjU"]
        let keyAPI: [String: String] = ["key": "AIzaSyCnK3hpM2A-SzFVUsnUvcXkeP1H6DBP86o"]
        parameters.updateValues(keyAPI)

        return AF.request(
            path.URLString,
            method: method,
            parameters: parameters,
            encoding: encode,
            headers: HTTPHeaders(defaultHeader)
        )
        .dataRequestResponse()
    }
}
