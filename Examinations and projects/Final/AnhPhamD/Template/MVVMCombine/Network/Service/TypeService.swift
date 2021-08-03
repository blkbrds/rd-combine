//
//  TypesService.swift
//  MVVMCombine
//
//  Created by Van Le H. on 6/12/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation
import Alamofire

enum TypeService {
    case listType
    case listWork(typeId: String, offset: Int)
    case getCategory(key: String, strCategory: String)
    case getTagGroup(key: String)
    case getDetail(idDrink: String)
}

extension TypeService: TargetType {
    var baseURL: String {
        guard let baseURLStr = AppConfiguration.infoForKey(.baseURL) else { fatalError() }
        return baseURLStr
//        return baseURLStr / "types"
    }

    var path: String {
        switch self {
        case .listType:
            return ""
        case .listWork(let typeId, _):
            return "\(typeId)/works"
        case .getCategory(let key, let strCategory):
            return "filter.php?\(key)\(strCategory)"
        case .getTagGroup(let key):
            return "list.php?\(key)list"
        case .getDetail(let idDrink):
            return "lookup.php?i=\(idDrink)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .listType, .listWork, .getCategory, .getTagGroup, .getDetail:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case .listType, .getCategory, .getTagGroup, .getDetail:
            return nil
        case .listWork(_, let offset):
            return ["offset": "\(offset)"]
        }
    }

    var headers: [String: String]? {
        switch self {
        case .listType, .listWork:
            return NetworkingController.defaultHeaders
        case .getCategory, .getTagGroup, .getDetail:
            return nil
        }
    }
}
