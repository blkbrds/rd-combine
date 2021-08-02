//
//  Error.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/16/21.
//

import Foundation

enum APIError: Error {
    case error(String)
    case errorURL
    case invalidResponse
    case errorParsing
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .error(let string):
            return string
        case .errorURL:
            return "URL String is error."
        case .invalidResponse:
            return "Invalid response"
        case .errorParsing:
            return "Failed parsing response from server"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}
