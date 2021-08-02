//
//  LoginViewModel.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/12/21.
//

import Foundation
import Combine

final class LoginViewModel: ObservableObject {

    enum SignInError: Error {
        case invalidUsernameLength
        case invalidUsername
        case invalidPasswordLength
        case unknown
        case noMatch
        case match
        case none

        var message: String {
            switch self {
            case .invalidUsernameLength:
                return Strings.Login.invalidUserNameLength
            case .invalidUsername:
                return Strings.Login.invalidUsername
            case .invalidPasswordLength:
                return Strings.Login.invalidPasswordLength
            case .unknown:
                return "Lỗi không xác định"
            case .none:
                return "Hop le"
            case .noMatch:
                return "User name hoặc password không đúng"
            case .match:
                return ""
            }
        }
    }

    @Published var userName: String = ""
    @Published var password: String = ""

    var users: [UserResponse] = Session.shared.users
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    

    var validateUserName: AnyPublisher<SignInError, Never> {
        return $userName
            .map { (2...20) ~= $0.count ? .none : $0.containsEmoji ? .invalidUsername : .invalidUsernameLength }
            .eraseToAnyPublisher()
    }

    var validatePassword: AnyPublisher<SignInError, Never> {
        return $password
            .map { (8...20) ~= $0.count ? .none : .invalidPasswordLength }
            .eraseToAnyPublisher()
    }

    var readyToLogin: AnyPublisher<Bool, Never> {
        return validateUserName
            .combineLatest(validatePassword)
            .map { $0.0 == .none && $0.1 == .none }
            .eraseToAnyPublisher()
    }

    var checkUser: AnyPublisher<SignInError, Never> {
        return $userName
            .combineLatest($password)
            .map { name, pw in
                for user in self.users where user.userName == name && user.password == pw {
                    return .match
                }
                return .noMatch
            }
            .eraseToAnyPublisher()
    }
}
