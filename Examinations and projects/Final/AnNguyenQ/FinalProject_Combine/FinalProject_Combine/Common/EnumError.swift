//
//  LoginError.swift
//  FinalProject_Combine
//
//  Created by An Nguyen Q. VN.Danang on 7/9/21.
//

import Foundation

enum LoginError: Error {
    case invalidPasswordLength
    case wrongFormatEmail
    case confirmPasswordNotCorrect
    case unknown

    var message: String {
        switch self {
        case .invalidPasswordLength:
            return "Password can only contain from 6 to 18 characters"
        case .unknown:
            return "Unknown Error"
        case .wrongFormatEmail:
            return "Email is not properly formatted"
        case .confirmPasswordNotCorrect:
            return "Password and confirm password are not the same"
        }
    }
}
