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
    let error = PassthroughSubject<SignInError, Never>()
    
    init() {
        isValidate = Publishers.CombineLatest($email, $password)
            .map { email, password -> Bool in
                guard let email = email, let password = password else { return false }
                return  self.valiDate(email: email, password: password)
            }
            .eraseToAnyPublisher()
        $email
            .map { String($0 ?? "") }
            .sink { email in
                self.valiDateEmail(email: email)
            }
            .store(in: &subscriptions)
        $password
            .map { String($0 ?? "") }
            .sink { password in
                self.valiDatePassword(password: password)
            }
            .store(in: &subscriptions)
    }
    
    func valiDate(email: String, password: String) -> Bool {
        if email.count >= 2 && email.count <= 20 && password.count >= 8 && password.count <= 20 && !email.containsEmoji {
            return true
        } else {
            return false
        }
    }
    
    func valiDateEmail(email: String) {
        if email.count < 2 && email.count > 20 {
            error.send(.invalidUsernameLength)
        } else if email.containsEmoji {
            error.send(.invalidUsername)
        }
    }
    
    func valiDatePassword(password: String) {
        if password.count < 8 && password.count > 20 {
            error.send(.invalidPasswordLength)
        }
    }
}
