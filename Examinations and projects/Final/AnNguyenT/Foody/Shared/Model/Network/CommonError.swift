//
//  ResponseError.swift
//  Foody
//
//  Created by MBA0283F on 4/8/21.
//

import Moya

enum CommonError: Error, Identifiable, Equatable {
    case invalidData
    case invalidInputData
    case invalidJSONFormat
    case authen
    case apiKey
    case network
    case cancelRequest
    case emptyData
    case noResponse
    case invalidURL
    case invalidAreaCode
    case timeout
    case unknown(String)
    case expiredToken
    case isBlocked
    
    var id: String { UUID().uuidString }
    
    var description: String {
        switch self {
        case .isBlocked:
            return "Your account has been locked due to reporting.\n Please call admin for help with this."
        case .expiredToken:
            return "Token is expired."
        case .timeout:
            return "Request timeout."
        case .apiKey:
            return ""
        case .invalidURL:
            return "Cannot detect URL."
        case .authen:
            return "Unauthorized."
        case .noResponse:
            return "No response."
        case .emptyData:
            return "Empty data."
        case .cancelRequest:
            return "Server returns no information and closes the connection."
        case .network:
            return "The internet connection appears to be offline."
        case .invalidJSONFormat:
            return "Invalid JSON Format"
        case .invalidData:
            return "Invalid Data Format."
        case .unknown(let description):
            return description
        case .invalidAreaCode:
            return "Invalid area code."
        case .invalidInputData:
            return "Invalid input data."
        }
    }
    
    
}
