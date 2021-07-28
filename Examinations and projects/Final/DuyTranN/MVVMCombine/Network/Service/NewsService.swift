//
//  NewsService.swift
//  MVVMCombine
//
//  Created by Duy Tran on 7/27/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation
import Alamofire

enum NewsService {
    case articles
    case searchArticles(keyword: String)
}

extension NewsService: TargetType {
    var baseURL: String {
        guard let baseURLStr = AppConfiguration.infoForKey(.baseURL) else { fatalError() }
        return baseURLStr / "v2"
    }

    var path: String {
        switch self {
        case .articles, .searchArticles:
            return "everything"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .articles, .searchArticles:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case .articles:
            return [
                "q": "Apple",
                "from": "2021-07-27",
                "sortBy": "popularity",
                "apiKey": "0e3aedb5dfc749a99ea88056bcf94082"
            ]
        case .searchArticles(let keyword):
            return [
                "q": keyword,
                "from": "2021-07-27",
                "sortBy": "popularity",
                "apiKey": "0e3aedb5dfc749a99ea88056bcf94082"
            ]
        }
    }

    var headers: [String: String]? {
        switch self {
        case .articles, .searchArticles:
            return NetworkingController.defaultHeaders
        }
    }
}
