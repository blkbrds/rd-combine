//
//  API.Constant.swift
//  FinalCombine
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 7/20/21.
//

import Foundation

struct APIConstant {

    static let baseURLString: String = "https://tasty.p.rapidapi.com/recipes"
}

typealias APIOutput = URLSession.DataTaskPublisher.Output

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

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
