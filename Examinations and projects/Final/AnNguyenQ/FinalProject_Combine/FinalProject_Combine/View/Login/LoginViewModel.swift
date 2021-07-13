//
//  LoginViewModel.swift
//  FinalProject_Combine
//
//  Created by An Nguyen Q. VN.Danang on 7/7/21.
//

import Foundation
import Combine

enum Completion: Equatable {
    case success
    case failure(LoginError)
}

final class LoginViewModel {
    var username: CurrentValueSubject<String, Never> = CurrentValueSubject<String, Never>("")
    var password: CurrentValueSubject<String, Never> = CurrentValueSubject<String, Never>("")
    
    var validateUserNamePublisher: AnyPublisher<Completion, Never> {
        username
            .map { value -> Completion in
                if value.count < 6 || value.count > 18 {
                    return Completion.failure(LoginError.invalidUsernameLength)
                }
                if value.containsEmoji {
                    return Completion.failure(LoginError.invalidUsername)
                }
                return Completion.success
            }
            .eraseToAnyPublisher()
    }
//
//    var isUsernameValidate: AnyPublisher<Bool, Never> {
//        username
//            .compactMap { value in
//                if value.count < 6 || value.count > 18 {
//                    return false
//                }
//                if value.containsEmoji {
//                    return false
//                }
//                return true
//            }
//            .eraseToAnyPublisher()
//    }
//
    var validatePasswordPublisher: AnyPublisher<Completion, Never> {
        password
            .map { value -> Completion in
                if value.count < 6 || value.count > 18 {
                    return Completion.failure(LoginError.invalidUsernameLength)
                }
                if value.containsEmoji {
                    return Completion.failure(LoginError.invalidUsername)
                }
                return Completion.success
            }
            .eraseToAnyPublisher()
    }
}
