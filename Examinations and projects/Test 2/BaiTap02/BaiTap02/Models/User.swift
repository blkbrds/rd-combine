//
//  User.swift
//  BaiTap02
//
//  Created by Trin Nguyen X on 4/13/21.
//  Copyright © 2021 Trin Nguyen Xuan. All rights reserved.
//

import Foundation

struct User {
    var id: String = UUID().uuidString
    var name: String
    var address: String
    var password: String = "12345678"
}
