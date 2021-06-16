//
//  API.Constant.swift
//  CombineDemoError
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 6/11/21.
//

import Foundation

struct APIConstant {

    static let baseURLString: String = "https://www.thecocktaildb.com/api/json/v1/1"
}

typealias APIOutput = URLSession.DataTaskPublisher.Output

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

// MARK: - Define name error
extension NSError {

    static var unknown: NSError {
        NSError(message: "An unknown error occurred.")
    }
    static var login: NSError {
        NSError(message: "Login failed. Please try again!")
    }
    static var service: NSError {
        NSError(message: "Service error. Please try again!")
    }
    static var response: NSError {
        NSError(message: "Service error. Please try again!")
    }
    static var json: NSError {
        NSError(code: 3_840, message: "The operation could not be completed.")
    }
}

enum APIError: Error {
    case error(String)
    case errorURL
    case invalidResponse
    case errorParsing
    case json
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
        case .json:
            return "The operation could not be completed."
        }
    }
}
