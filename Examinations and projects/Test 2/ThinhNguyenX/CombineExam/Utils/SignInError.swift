//
//  LoginError.swift
//  CombineExam
//
//  Created by Van Le H. on 4/11/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___ All rights reserved.
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
