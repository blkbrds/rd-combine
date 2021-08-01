//
//  ApiManager.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/21/21.
//

import Foundation
import Alamofire
import SwiftUtils
import Combine

typealias JSObject = [String: Any]
typealias JSArray = [JSObject]

enum APIResult<T> {
    case success(T)
    case failure(Error)
    case none
}

let api: ApiManager = ApiManager()

class ApiManager {
//    let manager = Session.default
//    let session = Session()
}

// MARK: URLStringConvertible
protocol URLStringConvertible {
    var URLString: String { get }
}

// MARK: URL
extension URL: URLStringConvertible {
    var URLString: String { return absoluteString }
}

// MARK: String
extension String: URLStringConvertible {
    var URLString: String { return self }
}

// MARK: CustomStringConvertible
extension CustomStringConvertible where Self: URLStringConvertible {
    var URLString: String { return description }
}

// MARK: Int
extension Int: URLStringConvertible {
    var URLString: String { return String(describing: self) }
}

// MARK: URLRequest
extension URLRequest: URLStringConvertible {
    var URLString: String { return url?.URLString ?? "" }
}
