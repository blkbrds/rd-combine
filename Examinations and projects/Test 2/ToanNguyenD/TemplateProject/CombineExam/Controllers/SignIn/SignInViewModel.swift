//
//  SignInViewModel.swift
//  CombineExam
//
//  Created by MBP0051 on 4/11/21.
//

import Foundation
import Combine

final class SignInViewModel {

    @Published var email: String = ""
    @Published var password: String = ""
    var userLocalFromDB: [User] = LocalDatabase.users
    let validationResult = PassthroughSubject<Void, Error>()

    private(set) lazy var isInputValid = Publishers.CombineLatest($email, $password)
        .map { $0.count >= 2 && $0.count <= 20
            && !$0.containsEmoji
            && $1.count >= 8 && $1.count <= 20 }
        .eraseToAnyPublisher()

    func isValidUser() -> Bool {
        return (userLocalFromDB.first(where: { $0.name == email && $0.password == password }) != nil)
    }
}
