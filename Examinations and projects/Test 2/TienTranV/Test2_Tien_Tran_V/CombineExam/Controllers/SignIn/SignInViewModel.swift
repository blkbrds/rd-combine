//
//  SignInViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

typealias Compeletion = (Result<(), SignInError>) -> Void

final class SignInViewModel {
    @Published var username: String = ""
    @Published var password: String = ""
    let validationResult = PassthroughSubject<(Bool, SignInError?), SignInError>()
    let validationInput = PassthroughSubject<(Bool, SignInError?), SignInError>()
}

extension SignInViewModel {

    func signIn(_ completion: @escaping () -> Void) {
        SignInSerVice.signIn(username: username, password: password) { [weak self] result in
            guard let this = self else {
                completion()
                return
            }
            switch result {
            case .success:
                this.validationResult.send((true, nil))
            case .failure(let error):
                this.validationResult.send((false, error))
            }
            completion()
        }
    }

    func checkValidate() {
        var isValid = true
        if !(username.count >= 2 && username.count <= 20) {
            validationInput.send((false, .invalidUsernameLength))
            isValid = false
            return
        }
        if username.containsEmoji {
            validationInput.send((false, .invalidUsername))
            isValid = false
            return
        }
        if !password.validate(String.passwordRegex) {
            validationInput.send((false, .invalidPasswordLength))
            isValid = false
            return
        }
        if isValid {
            validationInput.send((true, nil))
        }
    }
}

final class SignInSerVice {

    static func signIn(
        username: String,
        password: String,
        completion: @escaping Compeletion) {
        let time: DispatchTime = .now() + .milliseconds(Int.random(in: 200 ... 1_000))
        let isValid = validUser(username, password)
        DispatchQueue.main.asyncAfter(deadline: time) {
            if isValid {
                completion(.success(()))
            } else {
                completion(.failure(SignInError.signInFail))
            }
        }
    }

    static func validUser(_ username: String, _ password: String) -> Bool {
        let usersData = LocalDatabase.users
        for user in usersData {
            if user.name == username && user.password == password {
                return true
            } else {
                continue
            }
        }
        return false
    }
}
