//
//  LoginError.swift
//  FinalProject_Combine
//
//  Created by An Nguyen Q. VN.Danang on 7/9/21.
//

import Foundation

enum LoginError: Error {
    case invalidUsernameLength
    case invalidUsername
    case invalidPasswordLength
    case unknown

    var message: String {
        switch self {
        case .invalidUsernameLength:
            return "Username can only contain from 6 to 18 characters"
        case .invalidUsername:
            return "Username is not allowed to contain emoji"
        case .invalidPasswordLength:
            return "Password can only contain from 6 to 18 characters"
        case .unknown:
            return "Unknown Error"
        }
    }
}
