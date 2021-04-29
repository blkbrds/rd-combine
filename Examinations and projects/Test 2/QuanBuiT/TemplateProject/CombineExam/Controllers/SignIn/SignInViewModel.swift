//
//  SignInViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class SignInViewModel {
    var subscriptions: Set<AnyCancellable> = []
    @Published var email: String?
    @Published var password: String?
    var isValidate: AnyPublisher<Bool, Never>?
    
    init() {
        isValidate = Publishers.CombineLatest($email, $password)
            .map { email, password -> Bool in
                guard let email = email, let password = password else { return false }
                return  self.valiDate(email: email, password: password)
            }
            .eraseToAnyPublisher()
    }
    
    func valiDate(email: String, password: String) -> Bool {
        if email.count >= 2 && email.count <= 20 && password.count >= 8 && password.count <= 20 && !email.containsEmoji {
            return true
        } else {
            return false
        }
    }
    
    func valiDateEmail(email: String) -> String {
        if email.count < 2 || email.count > 20 {
            return SignInError.invalidUsernameLength.message
        } else if email.containsEmoji {
            return SignInError.invalidUsername.message
        }
        return ""
    }
    
    func valiDatePassword(password: String) -> String{
        if password.count < 8 || password.count > 20 {
            return SignInError.invalidPasswordLength.message
        }
        return ""
    }
}
