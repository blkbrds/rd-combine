//
//  SignInViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class SignInViewModel {

    @Published var userName: String = ""
    @Published var password: String = ""

    var usersAvailable: [User] = LocalDatabase.users

    var validateUserName: AnyPublisher<SignInError, Never> {
        return $userName
            .map { (2...20) ~= $0.count ? .none : $0.containsEmoji ? .invalidUsername : .invalidUsernameLength }
            .eraseToAnyPublisher()
    }

    var validatePassword: AnyPublisher<SignInError, Never> {
        return $password
            .removeDuplicates()
            .map { (8...20) ~= $0.count ? .none : .invalidPasswordLength }
            .eraseToAnyPublisher()
    }

    var readyToSignIn: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest(validateUserName, validatePassword)
            .map { $0 == .none && $1 == .none }
            .eraseToAnyPublisher()
    }

    func login(_ userName: String, _ password: String, completion: @escaping (Bool) -> ()) {
        DispatchQueue.main.async {
            completion(self.usersAvailable.contains(where: { userName == $0.name && password == $0.password }))
        }
    }

}
