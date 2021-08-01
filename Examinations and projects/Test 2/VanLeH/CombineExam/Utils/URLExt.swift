//
//  URLExt.swift
//  CombineExam
//
//  Created by Van Le H. on 5/7/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation
import Combine

extension URL {
    func requestApi<T: Decodable>(_ type: T.Type) -> AnyPublisher<T, ClientError> {
        let urlRequest = URLRequest(url: self)
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .receive(on: DispatchQueue.main)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw ClientError.invalidResponse
                }
                if 200...299 ~= response.statusCode {
                    return output.data
                } else if 204...205 ~= response.statusCode {
                    return Data()
                } else {
                    throw ClientError.unknow
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> ClientError in
                    if let error = error as? ClientError {
                        return error
                    } else {
                        switch error {
                        case is URLError:
                            return ClientError.unableToCreateRequest
                        case is DecodingError:
                            return ClientError.invalidResponse
                        default:
                            return ClientError.unknow
                        }
                    }
            }
            .eraseToAnyPublisher()
    }
}
