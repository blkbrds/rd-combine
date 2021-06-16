//
//  API.Target.swift
//  CombineDemoError
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 6/11/21.
//

import Foundation

// Protocol target type

protocol APITargetType {

    var baseURLString: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
    var sampleData: Data { get }
}

enum APITarget: APITargetType {

    case search(_ keyword: String)
    case listall(_ keyword: String)

    var baseURLString: String {
        return APIConstant.baseURLString
    }

    var path: String {
        switch self {
        case .search, .listall: return "/search.php"
        }
    }

    var method: HTTPMethod {
        .get
    }

    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }

    var parameters: [String: Any]? {
        switch self {
        case .search(let keyword):
            return ["s": keyword]
        case .listall(let keyword):
            return ["f": keyword]
        }
    }

    var sampleData: Data {
        return Data()
    }
}
