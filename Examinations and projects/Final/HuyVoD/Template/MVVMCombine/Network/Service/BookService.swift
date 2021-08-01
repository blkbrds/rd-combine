//
//  BookService.swift
//  MVVMCombine
//
//  Created by Huy Vo D. [2] VN.Danang on 7/30/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation
import Alamofire

enum BookService {
    case listBook(key: String, curentPage: Int)
    case newBook
    case detailBook(id: String)
}

extension BookService: TargetType {
    var baseURL: String {
        return "https://api.itbook.store/1.0"
    }
    
    var path: String {
        switch self {
        case .listBook(key: let key, curentPage: let curentPage):
            return "search/\(key)/\(curentPage)"
        case .newBook:
            return "anew"
        case .detailBook(id: let id):
            return "books/\(id)"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters? {
        return nil
    }
    
    var headers: [String : String]? {
        return nil
    }
}
