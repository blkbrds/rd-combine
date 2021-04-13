//
//  RestauranService.swift
//  List-NavigationDemo
//
//  Created by MBA0321 on 3/5/21.
//

import Foundation
import Combine

enum RestauranService {
    case trendings(page: Int)
    case populars(page: Int)
}

extension RestauranService: TargetType {

    var baseURL: URL {
        return URL(string: "https://gateway.chotot.com")!
    }

    var path: String {
        switch self {
        case .trendings:
            return "/v1/public/ad-listing"
        case .populars:
            return "/v1/public/ad-listing"
        }
    }

    var method: HTTPMethod {
        return .get
    }

    var sampleData: Data { Data() }

    var parameters: [String: Any] {
        var params: [String: Any] = [:]
        switch self {
        case .trendings(let page):
            params["cg"] = 3000
            params["limit"] = 20
            if page != 1 {
                params["o"] = 20 * (page - 1)
            }
        case .populars(let page):
            params["cg"] = 0
            params["key_param_included"] = true
            params["limit"] = 20
            params["sp"] = 0
            if page != 1 {
                params["o"] = 20 * (page - 1)
            }
        }
        return params
    }

    var headers: [String : String]? {
        let params: [String: String] = [:]
        return params
    }
}
