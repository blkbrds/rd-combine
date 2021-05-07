//
//  SignInViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class SignInViewModel {

    var usernameSubject: CurrentValueSubject = CurrentValueSubject<String?, Never>(nil)
    var passwordSubject: CurrentValueSubject = CurrentValueSubject<String?, Never>(nil)

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

                return nil
            }
            .eraseToAnyPublisher()
    }

    var passwordError: AnyPublisher<SignInError?, Never> {
        passwordSubject
            .map {
                guard let password = $0 else { return nil }
                if password.count < 6 || password.count > 8 {
                    return SignInError.invalidPasswordLength
                }

                return nil
            }
            .eraseToAnyPublisher()
    }
}
