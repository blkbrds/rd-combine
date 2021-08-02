//
//  SignUpViewModel.swift
//  MVVMCombine
//
//  Created by Huy Vo D. [2] VN.Danang on 7/29/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation
import Combine

final class SignUpViewModel {
    var usernameSubject: CurrentValueSubject = CurrentValueSubject<String?, Never>("")
    var passwordSubject: CurrentValueSubject = CurrentValueSubject<String?, Never>("")
    var resubmitPasswordSubject: CurrentValueSubject = CurrentValueSubject<String?, Never>("")

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
    
    var resubmitPassWordError: AnyPublisher<SignInError?, Never> {
        resubmitPasswordSubject
            .map { [weak self] in
                guard let password = $0 else { return nil }
                if password != self?.passwordSubject.value {
                    return SignInError.notSame
                }
                
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
