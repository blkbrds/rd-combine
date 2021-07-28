//
//  RegisterViewModel.swift
//  FinalProject_Combine
//
//  Created by An Nguyen Q. VN.Danang on 7/13/21.
//

import Foundation
import Combine

final class RegisterViewModel {
    var username: CurrentValueSubject<String, Never> = CurrentValueSubject<String, Never>("")
    var password: CurrentValueSubject<String, Never> = CurrentValueSubject<String, Never>("")
    var confirmPassword: CurrentValueSubject<String, Never> = CurrentValueSubject<String, Never>("")

    var validateUserNamePublisher: AnyPublisher<Completion, Never> {
        username
            .map { value -> Completion in
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
                if value.count < 6 || value.count > 18 {
                    return Completion.failure(LoginError.invalidPasswordLength)
                }
                
                return Completion.success
            }
            .eraseToAnyPublisher()
    }
    
    var validateConfirmPasswordPublisher: AnyPublisher<Completion, Never> {
        password
            .combineLatest(confirmPassword) { pw, confirmPW -> Completion in
                if pw != confirmPW {
                    return Completion.failure(LoginError.confirmPasswordNotCorrect)
                }
                return Completion.success
            }
            .eraseToAnyPublisher()
            
    }
}
