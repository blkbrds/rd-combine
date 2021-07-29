//
//  LoginError.swift
//  LyTruongH
//
//  Created by Ly Truong H. VN.Danang on 27/07/2021.
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
