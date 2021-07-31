//
//  User.swift
//  LyTruongH
//
//  Created by Ly Truong H. VN.Danang on 27/07/2021.
//

import Foundation
import Combine

struct User {
    var id: String = UUID().uuidString
    var name: String
    var address: String
    var password: String
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
