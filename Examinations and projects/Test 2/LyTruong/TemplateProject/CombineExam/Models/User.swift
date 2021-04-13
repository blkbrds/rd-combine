//
//  User.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

struct User {
    var id: String = UUID().uuidString
    var name: String
    var address: String
    var password: String = "12345678"
}

protocol UserServiceProtocol {
    func login(userName: String, passWord: String) -> AnyPublisher<Void, SignInError>
}

final class UserService: UserServiceProtocol {
    func login(userName: String, passWord: String) -> AnyPublisher<Void, SignInError> {
        return Future<Void, SignInError> { promise in
            print(promise)
        }.eraseToAnyPublisher()
    }
}
