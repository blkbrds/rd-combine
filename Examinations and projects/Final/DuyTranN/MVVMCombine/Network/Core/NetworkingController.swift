//
//  NetworkingController.swift
//  MVVMCombine
//
//  Created by Van Le H. on 6/12/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation
import Alamofire
import Combine

typealias ErasedDataResponsePublisher = AnyPublisher<(data: Data?, response: HTTPURLResponse?), Error>

final class NetworkingController {
    static var shared = NetworkingController()

    static var defaultHeaders: [String: String] {
        return ["Content-Type": "application/json"]
//        return ["User-Agent": "mailto:van.le@monstar-lab.com",
//                "Content-Type": "application/json",
//                "X-Rate-Limit-Limit": AppConfiguration.infoForKey(.limit).content,
//                "X-Rate-Limit-Interval": AppConfiguration.infoForKey(.interval).content
//        ]
    }
    private init() { }

    func requestWithTarget(_ target: TargetType) -> ErasedDataResponsePublisher {
        let urlString = target.baseURL / target.path
        return request(method: target.method,
                       urlString: urlString,
                       parameters: target.parameters,
                       headers: target.headers)
    }

    private func request(method: HTTPMethod,
                         urlString: String,
                         parameters: Parameters? = nil,
                         headers: [String: String]? = nil) -> ErasedDataResponsePublisher {

        var encoding: ParameterEncoding
        switch method {
        case .get, .delete:
            encoding = URLEncoding()
        default:
            encoding = JSONEncoding()
        }

        var httpHeaders: HTTPHeaders?
        if let headers = headers {
            httpHeaders = HTTPHeaders(headers)
        }

        return AF
            .request(urlString,
                     method: method,
                     parameters: parameters,
                     encoding: encoding,
                     headers: httpHeaders)
            .publishData(queue: DispatchQueue.main)
            .tryMap { value in
                if let error = value.error {
                    throw error
                }
                return (value.data, value.response)
            }
            .eraseToAnyPublisher()
    }
}
