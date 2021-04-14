//
//  SignInViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class SignInViewModel {
    let usernamePublisher = PassthroughSubject<String, Never>()
    let passwordPublisher = CurrentValueSubject<String, Never>("")
    let signinErrorPublisher = CurrentValueSubject<String, Never>("")
    var subscriptions = Set<AnyCancellable>()
    var isValidateSuccess: Bool = false

    init() {
        sink()
    }
    
    private func sink() {
        usernamePublisher.combineLatest(passwordPublisher)
            .sink(receiveValue: {
                print("Data", $0, $1)
                self.isValidateSuccess = self.validateUsername(text: $0) && self.validatePassword(text: $1)
                print(self.isValidateSuccess)
            })
            .store(in: &subscriptions)

        signinErrorPublisher.sink(receiveValue: { print($0) })
            .store(in: &subscriptions)
    }
    
    
    private func validateUsername(text: String) -> Bool {
        if text.count < 2 || text.count > 20 {
            signinErrorPublisher.send(SignInError.invalidUsernameLength.message)
            return false
        }
        
        if text.containsEmoji {
            signinErrorPublisher.send(SignInError.invalidUsername.message)
            return false
        }
        return true
    }
    
    private func validatePassword(text: String) -> Bool {
        if text.count < 8 || text.count > 20 {
            signinErrorPublisher.send(SignInError.invalidPasswordLength.message)
            return false
        }
        return true
    }
}

