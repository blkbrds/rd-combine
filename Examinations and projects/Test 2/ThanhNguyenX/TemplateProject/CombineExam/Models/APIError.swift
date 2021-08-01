//
//  APIError.swift
//  CombineExam
//
//  Created by Thanh Nguyen X. on 05/06/21.
//

import Foundation

enum APIError: Error, LocalizedError {
    case unknown
    case badRequest
    case maintenance
    case decodingError
    case network(from: URLError)

    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown Error"
        case .badRequest:
            return "Bad Request"
        case .maintenance:
            return "Maintenance"
        case .decodingError:
            return "Decoding Error"
        case .network(let from):
            return from.localizedDescription
        }
    }
}
