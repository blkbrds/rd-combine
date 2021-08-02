//
//  Network.swift
//  Platform
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

public class Network: Networking {

    let session: URLSession

    public init(session: URLSession) {
        self.session = session
    }
    
    static let `default` = {
        Network(session: URLSession.shared)
    }()

    public func send(_ request: URLRequest, completion: @escaping (Result<Data, NetworkingError>) -> Void) {
        let task = session.dataTask(with: request) { data, response, error in
            switch (data, response, error) {
            case (_, _, .some(let error)):
                completion(.failure(.underlyingError(error)))
            case (.none, .some(let response), .none):
                if let httpResponse = response as? HTTPURLResponse {
                    completion(.failure(.abnormalResponse(httpResponse)))
                }
            case (.none, .none, .none):
                completion(.failure(.emptyResponse))
            case (.some(let data), _, _):
                completion(.success(data))
            }
        }
        task.resume()
    }
}
