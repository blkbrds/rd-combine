//
//  Networking.swift
//  Platform
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import Foundation

public enum NetworkingError: Error {
    case underlyingError(Error)
    case abnormalResponse(HTTPURLResponse)
    case emptyResponse
}

protocol Networking: class {
    var session: URLSession { get }
    func send(_ request: URLRequest, completion: @escaping (Result<Data, NetworkingError>) -> Void)
}
