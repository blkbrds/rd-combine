//
//  NetworkService.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/27/21.
//

import Foundation
import Alamofire
import Combine

enum NetworkService {
    case stores
    case storeDetail(id: Int)
    case gamePerStoreDetail(id: Int)
    case search
}

extension NetworkService: TargetType {
    var baseURL: String {
        return APIManager.shared.baseURL
    }
    
    var path: String {
        switch self {
        case .stores:
            return baseURL / "stores"
        case .storeDetail(let id):
            return baseURL / "stores" / "\(id)"
        case .gamePerStoreDetail(let id):
            return baseURL / "games" / "\(id)"
        case .search:
            return baseURL / "search"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }

    var parameters: Parameters? {
        return [
            "key": "10ac2eb5ec614737ad26e8d380042bdb"
        ]
    }
    
    var headers: [String : String]? {
        return APIManager.shared.headers
    }
}
