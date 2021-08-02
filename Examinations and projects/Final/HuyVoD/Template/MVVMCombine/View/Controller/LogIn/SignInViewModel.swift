//
//  SignInViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

enum SignInError: Error {
    case invalidUsernameLength
    case invalidUsername
    case invalidPasswordLength
    case notSame
    case isEmpty
    case unknown

    var message: String {
        switch self {
        case .invalidUsernameLength:
            return "Username chỉ được chứa từ 3 đến 20 ký tự"
        case .invalidUsername:
            return "Username không được phép chứa emoji"
        case .invalidPasswordLength:
            return "Password chỉ được chứa từ 8 đến 20 ký tự"
        case .unknown:
            return "Lỗi không xác định"
        case .notSame:
            return "Không trùng với password đã nhập"
        case .isEmpty:
            return ""
        }
    }
}

final class SignInViewModel {

    var usernameSubject: CurrentValueSubject = CurrentValueSubject<String?, Never>("")
    var passwordSubject: CurrentValueSubject = CurrentValueSubject<String?, Never>("")

    var usernameError: AnyPublisher<SignInError?, Never> {
        usernameSubject
            .map {
                guard let username = $0 else { return nil }
                if username.count < 3 || username.count > 8 {
                    return SignInError.invalidUsernameLength
                }

                if username.containsEmoji {
                    return SignInError.invalidUsername
                }
                
                if username.isEmpty {
                    return SignInError.isEmpty
                }

                return nil
            }
            .eraseToAnyPublisher()
    }

    var passwordError: AnyPublisher<SignInError?, Never> {
        passwordSubject
            .map {
                guard let password = $0 else { return nil }
                if password.count < 6 || password.count > 20 {
                    return SignInError.invalidPasswordLength
                }
                
                if password.isEmpty {
                    return SignInError.isEmpty
                }

                return nil
            }
            .eraseToAnyPublisher()
    }
}

struct LocalDatabase {
    static let users: [User] = [User(name: "Tram"),
                                User(name: "Buon"),
                                User(name: "Linh")]
}
