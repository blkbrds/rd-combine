//
//  APIHandler.swift
//  CombineExam
//
//  Created by Cuong Doan M. on 4/22/21.
//

import Foundation
import Combine

extension AnyPublisher where Output == APIOutput, Failure == Error {
    
    func tryMap<T: Decodable>(_ type: T.Type, decoder: JSONDecoder = JSONDecoder.customUTC(withFormat: .full)) -> AnyPublisher<APIResponse<T>, Error> {
        mapError { $0 }
            .tryMap {
                guard let response: HTTPURLResponse = $0.response as? HTTPURLResponse else {
                    throw NSError.response
                }
                if 200...299 ~= response.statusCode {
                    return $0.data
                }
                throw NSError.json
            }
            .decode(type: APIResponse<T>.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
