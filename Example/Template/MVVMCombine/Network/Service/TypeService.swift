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
    case listTeam
}

extension TypeService: TargetType {
    var baseURL: String {
        switch self {
        case .listType, .listWork(typeId: _, offset: _):
            guard let baseURLStr = AppConfiguration.infoForKey(.baseURL) else { fatalError() }
            return baseURLStr / "types"
        case .listTeam:
            return "https://www.thesportsdb.com/api/v1/json/1"
        }
    }

    var path: String {
        switch self {
        case .listType:
            return ""
        case .listWork(let typeId, _):
            return "\(typeId)/works"
        case .listTeam:
            return "search_all_teams.php?l=English%20Premier%20League"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .listType, .listWork, .listTeam:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case .listType, .listTeam:
            return nil
        case .listWork(_, let offset):
            return ["offset": "\(offset)"]
        }
    }

    var headers: [String: String]? {
        switch self {
        case .listType, .listWork, .listTeam:
            return NetworkingController.defaultHeaders
        }
    }
}
