//
//  User.swift
//  CombineFinalProject
//
//  Created by Tan Huynh T. VN.Danang on 7/25/21.
//

import Foundation
import ObjectMapper
import Alamofire

final class User: Mappable {

    var id = ""
    var email = ""
    var password = ""

    init() { }

    init?(map: Map) {
        id <- map["id"]
    }

    func mapping(map: Map) {
        email <- map["email"]
        password <- map["password"]
    }
}
