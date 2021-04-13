//
//  SignInViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class SignInViewModel {

    @Published var isValid: Bool = false
    var subscriptions = Set<AnyCancellable>()
    let user = User(name: "name", address: "Da Nang")
    let emailPublisher = CurrentValueSubject<String, Never>("")
    let pwdPublisher = CurrentValueSubject<String, Never>("")
    let noticePublisher = PassthroughSubject<SignInError, Never>()


    init() {
        send()
        noticePublisher.sink { (value) in
            print(value.message)
        }.store(in: &subscriptions)
    }

    func isValidEmail() -> Bool {
        if emailPublisher.value.count > 20 || emailPublisher.value.count < 2 {
            noticePublisher.send(SignInError.invalidUsernameLength)
        }
        if pwdPublisher.value.count > 20 || pwdPublisher.value.count < 8 {
            noticePublisher.send(SignInError.invalidPasswordLength)
        }
        if emailPublisher.value.containsEmoji {
            noticePublisher.send(SignInError.invalidUsername)
            return false
        }

        if emailPublisher.value.count <= 20,
           emailPublisher.value.count >= 2,
           !emailPublisher.value.containsEmoji,
           pwdPublisher.value.count >= 8,
           pwdPublisher.value.count <= 20 {
            return true
        }
        return false
    }

    func checkData() -> Bool {
        if emailPublisher.value == user.name,
           pwdPublisher.value == user.password {
            return true
        } else {
            return false
        }
    }

    func send() {
        emailPublisher.combineLatest(pwdPublisher).sink { (email, pass) in
            if self.isValidEmail() {
                self.isValid = true
            } else {
                self.isValid = false
            }
        }.store(in: &subscriptions)
    }
}

