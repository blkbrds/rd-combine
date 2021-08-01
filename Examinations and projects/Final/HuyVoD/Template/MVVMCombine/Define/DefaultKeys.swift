//
//  DefaultKeys.swift
//  MVVMCombine
//
//  Created by Huy Vo D. [2] VN.Danang on 7/30/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

private struct Config {
    static let listUsers: String = "ListUser"
    static let isLogged: String = "IsLogged"
}

extension DefaultsKeys {
    static let listUsers = DefaultsKey<[User]>(Config.listUsers, defaultValue: [])
    static let isLogged = DefaultsKey<Bool>(Config.isLogged, defaultValue: false)
}
