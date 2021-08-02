//
//  RegisterViewModel.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/12/21.
//

import Foundation
import Combine

final class RegisterViewModel: ObservableObject {

    enum PasswordCheck {
        case noMatch
        case valid
    }

    enum RegisterError: Error {
        case initial
        case invalidUserName
        case invalidPassword
        case invalidConfirmPassword
        case unknown
        case passed

        var localizedDescription: String {
            switch self {
            case .initial:
                return ""
            case .invalidUserName:
                return "User name phải từ 4 đến 16 kí tự"
            case .invalidPassword:
                return "Password phải từ 8 đến 20 kí tự"
            case .invalidConfirmPassword:
                return "Đã nhập không khớp với password phía trên"
            case .unknown:
                return "Unknown"
            case .passed:
                return ""
            }
        }
    }

    var userNameError = CurrentValueSubject<RegisterError, Never>(.initial)
    var passwordError = PassthroughSubject<RegisterError, Never>()
    @Published var userName: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isValid: Bool = false

    var validateUserName: AnyPublisher<RegisterError, Never> {
        return $userName
            .removeDuplicates()
            .map { (4...16) ~= $0.count ? .passed : .invalidUserName }
            .eraseToAnyPublisher()
    }

    var validatePassword: AnyPublisher<RegisterError, Never> {
        return $password
            .removeDuplicates()
            .map { (8...20) ~= $0.count ? .passed : .invalidPassword }
            .eraseToAnyPublisher()
    }

    var validateConfirmPassword: AnyPublisher<RegisterError, Never> {
        return $confirmPassword
            .removeDuplicates()
            .map { [self] in password == $0 ? .passed : .invalidConfirmPassword }
            .eraseToAnyPublisher()
    }

    var isPasswordValidPublisher: AnyPublisher<PasswordCheck, Never> {
        Publishers.CombineLatest(validatePassword, validateConfirmPassword)
            .map { $0 == $1 ? .valid : .noMatch }
            .eraseToAnyPublisher()
    }

    var readyToRegister: AnyPublisher<Bool, Never> {
        validateUserName
            .combineLatest(isPasswordValidPublisher)
            .map { $0.0 == .passed && $0.1 == .valid }
            .eraseToAnyPublisher()
    }
}
