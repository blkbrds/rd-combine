//
//  UserDetailViewModel.swift
//  FinalProject_Combine
//
//  Created by An Nguyen Q. VN.Danang on 7/23/21.
//

import Foundation
import Combine

final class UserDetailViewModel {
    var username: CurrentValueSubject<String, Never> = CurrentValueSubject<String, Never>("")
    var password: CurrentValueSubject<String, Never> = CurrentValueSubject<String, Never>("")
    
    var validateUserNamePublisher: AnyPublisher<Completion, Never> {
        username
            .map { value -> Completion in
                if value.isEmpty {
                    return Completion.success
                }
                if !value.isValidEmail {
                    return Completion.failure(LoginError.wrongFormatEmail)
                }

                return Completion.success
            }
            .eraseToAnyPublisher()
    }

    var validatePasswordPublisher: AnyPublisher<Completion, Never> {
        password
            .map { value -> Completion in
                if value.isEmpty {
                    return Completion.success
                }
                
                if value.count < 6 || value.count > 18 {
                    return Completion.failure(LoginError.invalidPasswordLength)
                }
                
                return Completion.success
            }
            .eraseToAnyPublisher()
    }
}
