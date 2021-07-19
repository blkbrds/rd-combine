//
//  API.Target.swift
//  FinalCombine
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 7/20/21.
//

import Foundation

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
    case lists(_ keyword: String)

    var baseURLString: String {
        return APIConstant.baseURLString
    }

    var path: String {
        switch self {
        case .lists: return "/list/"
        case .search: return "/search.php"
        }
    }

    var method: HTTPMethod {
        .get
    }

    var headers: [String: String]? {
        ["x-rapidapi-key": "ac69953935msh66b7a9c97b58349p1104e6jsnab390bc4fcc0",
         "x-rapidapi-host": "tasty.p.rapidapi.com"]
    }

    var parameters: [String: Any]? {
        switch self {
        case .lists(let keyword):
            return ["from": "0",
                    "size": "40",
                    "tags": "under_30_minutes",
                    "q": keyword]
        case .search(let keyword):
            return ["q": keyword]
        }
    }

    var sampleData: Data {
        return Data()
    }
}
