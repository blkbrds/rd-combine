//
//  Session.swift
//  MVVMCombine
//
//  Created by MBA0242P on 5/7/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation

final class Session {

    static let shared = Session()

    private init() { }
    
    var isLogged: Bool {
        get {
            return userDefaults[.isLogged]
        }
        set {
            userDefaults[.isLogged] = newValue
        }
    }
    
    var userLogin: [User] {
        get {
            if userDefaults[.listUsers].isEmpty {
                userDefaults[.listUsers] = LocalDatabase.users
            }
            return userDefaults[.listUsers]
        }
        set {
            userDefaults[.listUsers] = newValue
        }
    }
}

// MARK: - Protocol
protocol SessionProtocol: class {
}

// MARK: - Public Properties
extension Session: SessionProtocol {
}
