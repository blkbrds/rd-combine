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
}

extension TypeService: TargetType {
    var baseURL: String {
        guard let baseURLStr = AppConfiguration.infoForKey(.baseURL) else { fatalError() }
        return baseURLStr / "types"
    }

    var path: String {
        switch self {
        case .listType:
            return ""
        case .listWork(let typeId, _):
            return "\(typeId)/works"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .listType, .listWork:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case .listType:
            return nil
        case .listWork(_, let offset):
            return ["offset": "\(offset)"]
        }
    }

    var headers: [String: String]? {
        switch self {
        case .listType, .listWork:
            return NetworkingController.defaultHeaders
        }
    }
}
