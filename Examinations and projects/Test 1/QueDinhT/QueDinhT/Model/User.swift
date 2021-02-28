//
//  User.swift
//  QueDinhT
//
//  Created by MBA0023 on 2/28/21.
//

import Foundation

class User {
    var name: String = ""
    var address: String = ""

    init() { }

    init(name: String, address: String) {
        self.name = name
        self.address = address
    }
}
