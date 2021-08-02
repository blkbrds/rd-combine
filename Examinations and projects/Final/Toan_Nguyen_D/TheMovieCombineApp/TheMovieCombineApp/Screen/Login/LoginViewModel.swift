//
//  LoginViewModel.swift
//  TheMovieCombineApp
//
//  Created by Toan Nguyen D. [4] VN.Danang on 28/07/2021.
//

import Foundation
import Combine

enum ValidateStatus {
    case valid
    case invalid
}

final class LoginViewModel {
    @Published var userName: String?
    @Published var password: String?
    var subscriptions = Set<AnyCancellable>()

    lazy var inputValidatePublisher = $userName.combineLatest($password)
        .map { (user, pwd) -> ValidateStatus in
            if let user =  user,
               let pwd = pwd, let fisrtChar = user.first {
                if user.count > 2,
                   fisrtChar.isLetter,
                   pwd.count >= 6 {
                    return .valid
                } else {
                    return .invalid
                }
            } else {
                return .invalid
            }
        }.eraseToAnyPublisher()

    init() {
        getAuthen()
    }

    private func getAuthen() {
        if UserDefaults.standard.value(forKey: "requestToken") == nil {
            API.Authentication.getRequestToken().sink { (completion) in
                print("get token:", completion)
            } receiveValue: { (token) in
                AuthManager.shared.requestToken = token
            }.store(in: &subscriptions)
        }
    }

    func login() -> Future<Void, Error> {
        Future<Void, Error> { [weak self]
            promise in
            guard let this = self else { return }
            guard let name = this.userName, let pass = this.password else { return }
            API.Login.loginAccount(username: name, pwd: pass)
                .sink { (completion) in
                print("Login:", completion)
            } receiveValue: { (status) in
                switch status {
                case .success:
                    promise(.success(()))
                case .failure(code: let code):
                    switch code {
                    case 30:
                        print("User or pass invalid")
                    case 33:
                        this.getAuthen()
                        print("Token expired")
                    default:
                        break
                    }
                }
            }.store(in: &this.subscriptions)
        }
    }
}
