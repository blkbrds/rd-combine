//
//  User.swift
//  CombineTest1
//
//  Created by Van Le H. on 2/28/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation

final class User {
    var imageName: String
    var name: String
    var address: String

    init(imageName: String, name: String, address: String) {
        self.imageName = imageName
        self.name = name
        self.address = address
    }
}

