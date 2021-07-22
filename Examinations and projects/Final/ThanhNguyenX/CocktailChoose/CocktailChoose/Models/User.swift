//
//  User.swift
//  CocktailChoose
//
//  Created by Thanh Nguyen X. [4] VN.Danang on 07/22/21.
//

import Foundation
import SwiftyUserDefaults

final class User: Codable, DefaultsSerializable {
    var username: String?
    var password: String?

    init(username: String?, password: String?) {
        self.username = username
        self.password = password
    }
}
