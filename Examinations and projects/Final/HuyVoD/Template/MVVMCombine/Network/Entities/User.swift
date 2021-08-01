//
//  User.swift
//  MVVMCombine
//
//  Created by Huy Vo D. [2] VN.Danang on 7/29/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

struct User: DefaultsSerializable, Codable, Equatable {
    var name: String
    var password: String = "12345678"
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.name == rhs.name && lhs.password == rhs.password
    }
}
