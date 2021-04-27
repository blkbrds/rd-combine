//
//  Error.swift
//  List-NavigationDemo
//
//  Created by MBA0321 on 3/5/21.
//

import Foundation

enum APIError: Error, LocalizedError, Identifiable {
    var id: String { UUID().uuidString }

    case unknown
    case badRequest
    case maintenance
    case network(from: URLError)
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case .badRequest:
            return "Bad request"
        case .maintenance:
            return "Server is maintenance"
        case .network(let from):
            return from.localizedDescription
        }
    }
}
