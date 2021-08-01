//
//  ProvinceService.swift
//  BaiTapNetworking
//
//  Created by Trin Nguyen X on 4/22/21.
//  Copyright © 2021 Trin Nguyen Xuan. All rights reserved.
//

import Foundation

enum ProvinceService {
    case getName
}

extension ProvinceService: TargetType {
    var parameters: Parameters {
        switch self {
        case .getName:
            return [:]
        }
    }

    var baseURL: URL {
        return URL(string: "https://thongtindoanhnghiep.co/api/city")!
    }

//    var path: String {
//        switch self {
//        case .getName:
//            return "abc/qa"
//        }
//    }

    var sampleData: Data { Data() }

    var method: HTTPMethod {
        switch self {
        case .getName:
            return .get
        }
    }

    var headers: [String : String]? {
        switch self {
        case .getName:
            return nil
        }
    }
}
