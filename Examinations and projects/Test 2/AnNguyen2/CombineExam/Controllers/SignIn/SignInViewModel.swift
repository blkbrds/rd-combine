//
//  SignInViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Combine

enum Completion: Equatable {
    case suscess
    case failure(SignInError)
}

final class SignInViewModel {
    var username = CurrentValueSubject<String, Never>("")
    var password = CurrentValueSubject<String, Never>("")
    
    var validNamePublisher: AnyPublisher<Completion, Never> {
        username
            .map({ value -> Completion in
                if value.count < 2 || value.count >= 20 {
                    return Completion.failure(.invalidUsernameLength)
                } else if value.containsEmoji {
                    return Completion.failure(.invalidUsername)
                }
                return Completion.suscess
            })
            .eraseToAnyPublisher()
    }
    
    var validPasswordPublisher: AnyPublisher<Completion, Never> {
        password
            .map({ value -> Completion in
                if value.count < 8 || value.count >= 20 {
                    return Completion.failure(.invalidPasswordLength)
                }
                return Completion.suscess
            })
            .eraseToAnyPublisher()
    }
    
    var isValidUser: Bool {
        LocalDatabase.users.contains(where: { $0.name == username.value && $0.password == password.value })
    }
}
