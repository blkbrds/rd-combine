//
//  SignInViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class SignInViewModel {

    let userName: CurrentValueSubject = CurrentValueSubject<String, Never>("")
    let password: CurrentValueSubject = CurrentValueSubject<String, Never>("")
    let errorvalidation: CurrentValueSubject = CurrentValueSubject<SignInError?, Never>(nil)
    let loginStatus: CurrentValueSubject<Bool, Never> = CurrentValueSubject<Bool, Never>(false)
    var subscription = Set<AnyCancellable>()
    
    init() {
        userName.dropFirst().sink { [weak self] (name) in
            if name.count < 3 || name.count > 20 {
                self?.errorvalidation.send(SignInError.invalidUsernameLength)
            } else if name.containsEmoji {
                self?.errorvalidation.send(SignInError.invalidUsername)
            } else {
                self?.errorvalidation.send(nil)
            }
        }.store(in: &subscription)
        
        password.dropFirst().sink { [weak self] (pass) in
            if pass.count < 6 || pass.count > 20 {
                self?.errorvalidation.send(SignInError.invalidPasswordLength)
            } else {
                self?.errorvalidation.send(nil)
            }
        }.store(in: &subscription)

        userName.combineLatest(password).contains { (name, pass) -> Bool in
            return LocalDatabase.users.contains { (user) -> Bool in
                return user.name == name && user.password == pass
            }
        }.sink { [weak self] (value) in
            self?.loginStatus.send(value)
        }.store(in: &subscription)
    }
}
