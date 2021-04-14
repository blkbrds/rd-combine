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
    @Published var isLoading = false
    
    private(set) lazy var isInputValid = Publishers.CombineLatest($username, $password)
        .map { (username, password) -> SignInError? in
            if username.count < 2 || username.count > 20 {
                return .invalidUsernameLength
            } else if username.containsEmoji {
                return .invalidUsername
            }
            
            if password.count < 8 || password.count > 20 {
                return .invalidPasswordLength
            }
            return nil
        }
        .eraseToAnyPublisher()
    var stores: Set<AnyCancellable> = []

    var users: [User]
    
    init() {
        users = LocalDatabase.users
    }
}

extension SignInViewModel {

    func signIn(completion: @escaping () -> Void) {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
            completion()
        }
    }
}
