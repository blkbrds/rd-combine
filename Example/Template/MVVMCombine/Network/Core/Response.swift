//
//  Response.swift
//  MVVMCombine
//
//  Created by Van Le H. on 6/12/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation
import Combine

extension ErasedDataResponsePublisher {
    fileprivate func tryMapHTTPResponse() -> Publishers.TryMap<Self, Data> {
        tryMap {
            guard let response = $0.response else {
                throw APIError.emptyOrInvalidResponse
            }

            if 204...205 ~= response.statusCode {
                // empty data status code
                return Data()
            }

            guard 200...299 ~= response.statusCode else {
                var error: NSError!
                if let data = $0.data,
                    let responseData = try? JSONDecoder().decode(ResponseData<ErrorData>.self, from: data) {
                    let errorData = responseData.team
                    #if DEBUG
                    NSLog("API Error:", errorData.description, errorData.message)
                    for err in errorData.stack {
                        NSLog("API Error Stack:", err)
                    }
                    #endif
                    if let message = errorData.cause {
                        error = NSError(domain: AppConfiguration.infoForKey(.baseURL).content,
                                      code: response.statusCode,
                                      userInfo: [NSLocalizedDescriptionKey: message])
                    } else {
                        throw APIError.unknown
                    }
                } else {
                    throw APIError.unknown
                }
                throw error
            }

            guard let data = $0.data else {
                throw APIError.emptyOrInvalidResponse
            }
            return data
        }
    }

    func response<T: Decodable>(_ type: T.Type) -> AnyPublisher<T, Error> {
        return self
            .tryMapHTTPResponse()
            .decode(type: ResponseData<T>.self, decoder: JSONDecoder())
            .map { $0.team }
            .eraseToAnyPublisher()
    }

//    func responseTeam<T: Decodable>(_ type: T.Type) -> AnyPublisher<T, Error> {
//        return self
//            .tryMapHTTPResponse()
//            .decode(type: ResponseTeam<T>.self, decoder: JSONDecoder())
//            .map { $0.teams }
//            .eraseToAnyPublisher()
//    }
}
