//
//  SignInViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class SignInViewModel {
    @Published var username: String = ""
    @Published var password: String = ""

    var isValidate: AnyPublisher<Bool,Never>?
    init() {
        isValidate = Publishers.CombineLatest($username, $password)
            .map { username, password -> Bool in
                return self.checkEnable(username: username, password: password)
            }
            .eraseToAnyPublisher()
 
    }
    
    func validateUserName(username: String) -> String {
        if username.count < 2 || username.count > 20 {
            return SignInError.invalidUsernameLength.message
        } else if username.containsEmoji {
            return SignInError.invalidUsername.message
        }
        return ""
    }
    
    
    func validatePassword(password: String) -> String {
        if password.count < 8 || password.count > 20 {
            return SignInError.invalidPasswordLength.message
        }
        return ""
    }
    func checkEnable(username: String, password: String) -> Bool {
        if username.count >= 2 && username.count <= 20 && password.count > 7 && password.count < 20 {
            return true
        } else {
            return false
        }
    }
}
