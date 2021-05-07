//
//  SignInError.swift
//  BaiTap02
//
//  Created by Trin Nguyen X on 4/13/21.
//  Copyright © 2021 Trin Nguyen Xuan. All rights reserved.
//

import Foundation

enum SignInError: Error {
    case invalidUsernameLength
    case invalidUsername
    case invalidPasswordLength
    case unknown

    var message: String {
        switch self {
        case .invalidUsernameLength:
            return "Username chỉ được chứa từ 2 đến 20 ký tự"
        case .invalidUsername:
            return "Username không được phép chứa emoji"
        case .invalidPasswordLength:
            return "Password chỉ được chứa từ 8 đến 20 ký tự"
        case .unknown:
            return "Lỗi không xác định"
        }
    }
}
