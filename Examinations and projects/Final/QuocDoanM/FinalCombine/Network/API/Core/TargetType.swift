//
//  TargetType.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/27/21.
//

import Foundation
import Alamofire

protocol TargetType {

    var baseURL: String { get }
    
    var path: String { get }
    
    var method: HTTPMethod { get }

    var parameters: Parameters? { get }

    var headers: [String : String]? { get }
}
