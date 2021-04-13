//
//  SignInViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Combine

final class SignInViewModel {
    var username: String = ""
    var password: String = ""
    
    var validUsername: Bool {
        if username.count < 2 || username.count >= 20 {
            print(SignInError.invalidUsernameLength.message)
            return false
        } else if username.containsEmoji {
            print(SignInError.invalidUsername.message)
            return false
        }
        return true
    }
    
    var validatedPassword: Bool {
        if password.count < 8 || password.count >= 20 {
            print(SignInError.invalidPasswordLength)
            return false
        }
        return true
    }
    
    var checkValidUser: Bool {
        LocalDatabase.users.contains(where: { $0.name == username && $0.password == password })
    }
}
