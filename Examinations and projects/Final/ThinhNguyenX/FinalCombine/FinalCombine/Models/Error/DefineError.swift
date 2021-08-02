//
//  DefineError.swift
//  FinalCombine
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 8/2/21.
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
