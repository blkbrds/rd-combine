//
//  TargetType.swift
//  MVVMCombine
//
//  Created by Van Le H. on 6/12/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation
import Alamofire

protocol TargetType {

    var baseURL: String { get }

    var path: String { get }

    var method: HTTPMethod { get }

    var parameters: Parameters? { get }

    var headers: [String: String]? { get }
}
