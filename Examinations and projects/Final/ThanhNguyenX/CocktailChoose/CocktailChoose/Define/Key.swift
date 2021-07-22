//
//  Key.swift
//  CocktailChoose
//
//  Created by Thanh Nguyen X. [4] VN.Danang on 07/22/21.
//

import Foundation
import SwiftyUserDefaults

struct App { }

extension App {
    enum KeyUserDefault: String, CaseIterable {
        case userRegistered
    }
}

extension DefaultsKeys {
    static let userRegistered = DefaultsKey<[User]?>(App.KeyUserDefault.userRegistered.rawValue)
}
