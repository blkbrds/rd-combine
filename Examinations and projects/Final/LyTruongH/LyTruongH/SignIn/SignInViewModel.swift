//
//  SignInViewModel.swift
//  LyTruongH
//
//  Created by Ly Truong H. VN.Danang on 27/07/2021.
//

import Foundation
import Combine

final class SignInViewModel {
    
    // input
    @Published var username: String?
    @Published var password: String?
    
    var isValid: AnyPublisher<Bool, Never>?
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        isValid = Publishers.CombineLatest($username, $password)
            .map { user, pass -> Bool in
                guard let user = user, let pass = pass else { return false }
                return self.validate(userName: user, passWord: pass)
            }
            .eraseToAnyPublisher()
    }
    
    func validate(userName: String, passWord: String) -> Bool {
        return validateEmail(username ?? "") && validatePass(password ?? "")
    }
    
    func validateEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func validatePass(_ pass: String) -> Bool {
        if pass.count >= 8 && pass.count <= 20 {
            return true
        }
        return false
    }
}
