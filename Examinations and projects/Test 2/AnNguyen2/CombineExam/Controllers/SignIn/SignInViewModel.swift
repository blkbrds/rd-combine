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
    
    var inValidUsername: SignInError? {
        if username.count < 2 || username.count >= 20 {
            return SignInError.invalidUsernameLength
        } else if username.containsEmoji {
            return SignInError.invalidUsername
        }
        return nil
    }
    
    var validatedPassword: SignInError? {
        if password.count < 8 || password.count >= 20 {
            return SignInError.invalidPasswordLength
        }
        return nil
    }
    
    var checkValidUser: Bool {
        LocalDatabase.users.contains(where: { $0.name == username && $0.password == password })
    }
}
