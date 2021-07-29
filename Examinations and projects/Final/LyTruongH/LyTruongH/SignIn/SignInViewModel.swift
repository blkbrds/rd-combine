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
        if userName.count >= 2 && passWord.count >= 8 && passWord.count <= 20 && !userName.containsEmoji {
            return true
        } else {
            return false
        }
    }
    
    func validateUserName(userName: String) -> Bool {
        if userName.count < 2 || userName.count > 20 || userName.containsEmoji {
            return false
        } else {
            return true
        }
    }
    
    func validatePassWord(passWord: String) -> Bool {
        if passWord.count < 8 || passWord.count > 20 {
            return false
        } else {
            return true
        }
    }
}
