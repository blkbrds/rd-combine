//
//  APITarget.swift
//  CombineExam
//
//  Created by Cuong Doan M. on 4/20/21.
//

import Foundation
import CryptoKit

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
    
    var baseURLString: String {
        return APIConstant.baseURLString
    }
    
    var path: String {
        switch self {
        case .search: return "/search.php"
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
        }
    }
    
    var sampleData: Data {
        return Data()
    }
}
